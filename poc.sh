#!/usr/bin/env bash

#set -x

. ./get_fattura_pa.conf

check_dependencies()
{
    which \
        xmlstarlet \
        gawk \
        sha256sum \
        curl \
        openssl \
        base64
}

check_hash()
{
    local metadata_file="${1}"
    local signed_file="${2}"
    local ignore_hash_check="${3}"
    local metadata_file_xml_namespace="${4}"

    [ "${ignore_hash_check}" = 'true' ] && return 0

    # FIXME: should we get the file name?
    local original_hash="$(xmlstarlet sel \
        -N x="${metadata_file_xml_namespace}" \
        --template --match '//x:FileMetadati/Hash' \
        --value-of . "${metadata_file}")"
    local computed_hash="$(sha256sum --binary "${signed_file}" \
        | gawk '{print $1}')"

    [ "${original_hash}" != "${computed_hash}" ] && return 1
}

get_certificates()
{
    local trusted_certificates_list_url="${1}"
    local trusted_certificates_list_encoded_file="${2}"
    local trusted_certificates_list_decoded_file="${3}"
    local force_trusted_certificates_list_download="${4}"
    local trusted_certificates_list_encoded_file_xml_namespace="${5}"

    if [ "${force_trusted_certificates_list_download}" = 'true' ] \
        || [ ! -f "${trusted_certificates_list_encoded_file}" ]; then
        curl --progress-bar --verbose --retry 2 \
            --output "${trusted_certificates_list_encoded_file}" \
            "${trusted_certificates_list_url}"
    fi

    rm --recursive --force "${trusted_certificates_list_decoded_file}"

    # Check that it is a valid XML file.
    xmlstarlet val "${trusted_certificates_list_encoded_file}" || return 1

    xmlstarlet sel -N x="${trusted_certificates_list_encoded_file_xml_namespace}" \
        --template --match "//x:X509Certificate" --value-of . --nl \
        "${trusted_certificates_list_encoded_file}" \
        | while read -r -- cert; do
            printf "%s\n" '-----BEGIN CERTIFICATE-----' >> "${trusted_certificates_list_decoded_file}"
            printf "%s\n" "$(echo "${cert}" | openssl base64 -d -A | openssl base64)" \
                >> "${trusted_certificates_list_decoded_file}"
            printf "%s\n" '-----END CERTIFICATE-----' >> "${trusted_certificates_list_decoded_file}"
        done
}

check_signature()
{
    local signed_file="${1}"
    local trusted_certificates_list_decoded_file="${2}"
    local ignore_signature_check="${3}"

    [ "${ignore_signature_check}" = 'true' ] && return 0

    openssl smime -verify -CAfile "${trusted_certificates_list_decoded_file}" \
        -in "${signed_file}" -inform DER -out /dev/null
}

extract_file()
{
    local signed_file="${1}"
    local original_file="${2}"

    # -verify -noverify means to just extract the file without checking the
    # signature since this should have already been done in a previous step of
    # the pipeline.
    openssl smime -verify -noverify -in "${signed_file}" -inform DER -out "${original_file}"
}

extract_attachments()
{
    local original_file="${1}"
    local no_extract_attachment="${2}"
    local original_file_xml_namespace="${3}"

    [ "${no_extract_attachment}" = 'true' ] && return 0

    # Check that it is a valid XML file. We just need to exit if it's not an
    # XML file
    xmlstarlet val "${original_file}" || return 0

    # This is a loop for all the attachments.
    # We will use the attachment_name as the output file name.
    # We need to remove newline characters between each line of the Attachment
    # field. See https://stackoverflow.com/questions/14952640/xmlstarlet-removing-linefeed
    xmlstarlet sel --noblanks -N x="${original_file_xml_namespace}" \
        --template --match "//x:FatturaElettronica/FatturaElettronicaBody/Allegati" \
        --value-of "NomeAttachment" -o ' ' \
        --var linebreak --nl --break \
        --value-of "translate(Attachment,\$linebreak,'')" --nl "${original_file}" \
        | while read -r -- nome_attachment attachment; do
            echo "${attachment}" | base64 --decode --ignore-garbage > "${nome_attachment}"
        done
}

# . ./fbopt
# Pipeline.

check_dependencies \
    && check_hash "${metadata_file}" "${signed_file}" 'true' "${METADATA_FILE_XML_NAMESPACE}" \
    && get_certificates "${TRUSTED_CERTIFICATES_LIST_URL}" 'ca.enc' 'ca.pem' 'false' "${TRUSTED_CERTIFICATES_LIST_ENCODED_FILE_XML_NAMESPACE}" \
    && check_signature "${signed_file}" 'ca.pem' 'false' \
    && extract_file "${signed_file}" 'out.xml' \
    && extract_attachments 'out.xml' 'false' "${ORIGINAL_FILE_XML_NAMESPACE}"
