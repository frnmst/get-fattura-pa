# get-fattura-pa

The purpose of this script is exclusively to read invoices received from the
*Sistema di Interscambio*.

## Table of contents

[](TOC)

- [get-fattura-pa](#get-fattura-pa)
    - [Table of contents](#table-of-contents)
    - [Version](#version)
    - [Definitions](#definitions)
    - [Examples](#examples)
    - [Help](#help)
    - [Dependencies](#dependencies)
    - [Pipeline](#pipeline)
    - [Resources](#resources)
        - [Original script](#original-script)
        - [Fattura PA](#fattura-pa)
        - [PKCS # 7](#pkcs--7)
    - [License and copyright](#license-and-copyright)

[](TOC)

## Version

1.0.0

See all [get-fattura-pa releases](https://github.com/frnmst/get-fattura-pa/releases).

## Definitions

The following terms are used throughout this document and within the source 
code.

| Term | Meaning |
|------|---------|
| checksum | a file integrity check |
| signed file | the invoice file signed using a PKCS # 7 system |
| certificate | proves that the public key used for the signature is authentic |
| metadata file | a file that contains the checksum of the signed file as well as other information |
| original file | the invoice file without the signature |
| attachments | user certain conditions, the files encoded as base64 binaries in the original file |

## Examples

- Given a metadata file called `document.xml` and a signed file called 
  `document.xml.p7m`, you can verify and extract the original file
  and attachments with the following command:

      $ ./get_fattura_pa document.xml document.xml.p7m

- If you are not in possession of the metadata file or there is a problem with 
  it, you may also skip the checksum:

      $ ./get_fattura_pa --ignore-checksum /dev/null document.xml.p7m

## Help

```
Usage: get_fattura_pa [OPTION] METADATA_FILE SIGNED_FILE
The purpose of this script is exclusively to read invoices received from the
*Sistema di Interscambio*

Mandatory arguments to long options are mandatory for short options too.
Options:
    -c, --ignore-checksum                   avoid checksum comparision between
                                            the metadata file and the signed
                                            file
    -e, --ignore-certificate                avoid checking the certificate
                                            used by the signer
    -f, --force-certificates-download       update the certificate list even if
                                            a certificate file is already
                                            present
    -h, --help                              print this help
    -n, --no-extract-attachments            avoid extracting possible
                                            attachments if the original
                                            file is an XML file
    --print-flags                           print the enabled options. This can also
                                            be used to print the default options
    -q, --quiet                             show errors and hide every other
                                            output
    -s, --ignore-signature                  avoid checking the cryptographic
                                            signature of the file

Exit status:
 0  if OK,
 1  if an error occurred.

This  is  free  software: you are free to change and redistribute it.  There
is NO WARRANTY, to the extent  permitted by law.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
Copyright © 2018 Enio Carboni - Italy    (see https://github.com/eniocarboni/p7m)
            2019 Franco Masotti (frnmst) <franco.masotti@live.com>
```

## Dependencies

You need to install the following packages and the ones listed for 
[fbopt](https://github.com/frnmst/fbopt#dependencies) and 
[fbla](https://github.com/frnmst/fbla#dependencies):

| Package | Executable | Version command | Package version |
|---------|------------|-----------------|-----------------|
| [GNU coreutils](https://www.gnu.org/software/coreutils/) | `/bin/sha256sum`, `/bin/base64` | `$ ${Executable} --version` | `(GNU coreutils) 8.30` |
| [XMLStarlet](http://xmlstar.sourceforge.net/) | `/bin/xmlstarlet` |  `$ xmlstarlet --version` | `1.6.1 compiled against libxml2 2.9.8, linked with 20909 compiled against libxslt 1.1.32, linked with 10133-GITv1.1.33` |
| [GNU Awk](http://www.gnu.org/software/gawk/) | `/bin/gawk` | `$ gawk --version` |`GNU Awk 4.2.1, API: 2.0 (GNU MPFR 4.0.1, GNU MP 6.1.2)` |
| [curl](https://curl.haxx.se) | `/bin/curl` | `$ curl --version` | `curl 7.63.0 (x86_64-pc-linux-gnu) libcurl/7.63.0 OpenSSL/1.1.1a zlib/1.2.11 libidn2/2.1.0 libpsl/0.20.2 (+libidn2/2.1.0) libssh2/1.8.0 nghttp2/1.35.1 Release-Date: 2018-12-12` |
| [OpenSSL](https://www.openssl.org) | `/bin/openssl` | `$ openssl version` | `OpenSSL 1.1.1a  20 Nov 2018` |

## Pipeline

If there is a failure in any point of this pipeline the program stops and 
returns an error code.

| Step number | Actions | Optional | Suggested | Depends on step number |
|-------------|---------|----------|-----------|------------------------|
| 1 | check script dependencies | no | - | - |
| 2 | check input files | no | - | - |
| 3 | check signed file integrity given the metadata file (checksum) | yes | yes | - |
| 4 | get certificates from the government's website | yes | yes | - |
| 5 | check signature and signer's certificate of the signed file | yes | yes | 4 |
| 6 | extract the original file from the signed file | no | - | - |
| 7 | decode possible attachments from the original file | yes | yes | 6 |

## Resources

### Original script

- https://github.com/eniocarboni/p7m
- https://quoll.it/firma-digitale-p7m-come-estrarre-il-contenuto/

### Fattura PA

- https://it.wikipedia.org/wiki/Fattura_elettronica
- https://www.fatturapa.gov.it/export/fatturazione/it/index.htm
- https://www.fatturapa.gov.it/export/fatturazione/it/normativa/f-2.htm
- https://www.fatturapa.gov.it/export/fatturazione/sdi/Specifiche_tecniche_del_formato_FatturaPA_v1.2.1.pdf
- https://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2.1/Schema_del_file_xml_FatturaPA_versione_1.2.1.xsd

### PKCS # 7

- [RFC2315](https://tools.ietf.org/html/rfc2315)

## License and copyright

Copyright (c) 2018 Enio Carboni - Italy    (see https://github.com/eniocarboni/p7m)

Copyright (c) 2019 Franco Masotti (frnmst); franco [dot] masotti [at] live [dot] com

get-fattura-pa is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

get-fattura-pa is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with get-fattura-pa.  If not, see <https://www.gnu.org/licenses/>.
