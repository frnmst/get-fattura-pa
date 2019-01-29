# get_fattura_pa

The purpose of this script is exclusively to read invoices received from the
"Sistema di Interscambio".

## Examples

    $ ./get_fattura_pa document.xml.p7m

    TODO

## Dependencies

You need to install the following.

| Package | Executable | Version command | Package version |
|---------|------------|-----------------|-----------------|
| [GNU coreutils](https://www.gnu.org/software/coreutils/) | `/bin/sha256sum`, `/bin/base64` | `$ ${Executable} --version` | `(GNU coreutils) 8.30` |
| [XMLStarlet](http://xmlstar.sourceforge.net/) | `/bin/xmlstarlet` |  `$ xmlstarlet --version` | `1.6.1 compiled against libxml2 2.9.8, linked with 20909 compiled against libxslt 1.1.32, linked with 10133-GITv1.1.33` |
| [GNU Awk](http://www.gnu.org/software/gawk/) | `/bin/gawk` | `GNU Awk 4.2.1, API: 2.0 (GNU MPFR 4.0.1, GNU MP 6.1.2)` |
| [curl](https://curl.haxx.se) | `/bin/curl` | `$ curl --version` | `curl 7.63.0 (x86_64-pc-linux-gnu) libcurl/7.63.0 OpenSSL/1.1.1a zlib/1.2.11 libidn2/2.1.0 libpsl/0.20.2 (+libidn2/2.1.0) libssh2/1.8.0 nghttp2/1.35.1 Release-Date: 2018-12-12 Protocols: dict file ftp ftps gopher http https imap imaps pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp Features: AsynchDNS IDN IPv6 Largefile GSS-API Kerberos SPNEGO NTLM NTLM_WB SSL libz TLS-SRP HTTP2 UnixSockets HTTPS-proxy PSL` |
| [OpenSSL](https://www.openssl.org) | `/bin/openssl` | `$ openssl --version` | `OpenSSL 1.1.1a  20 Nov 2018` |

You also need to install the pacmages for 
[fbopt](https://github.com/frnmst/fbopt#dependencies)

## Help

TODO

## Definitions

| Term | Meaning |
|------|---------|
| signed file | the invoice file signed with a PCKS-7 public key |
| metadata file | a file that contains the checksum of the signed file as well as other information |
| original file | the invoice file without the signature |
| attachments | user certain conditions, the files encoded as base64 binaries in the original file |

## Pipeline

| Step Number | Actions | Optional | Suggested |
|-------------|---------|----------|-----------|
| 1 | check script dependencies | no | - |
| 2 | check signed file hash given the metadata file | yes | yes |
| 3 | get certificates from the government's website and transform them in a readable format for OpenSSL | yes | yes |
| 4 | check signature of signed file | yes | yes (step 3 is needed) |
| 5 | extract the original file from the signed file | no | - |
| 6 | decode possible attachments from the original file | yes | yes |

## Resources

### Original script

- https://quoll.it/firma-digitale-p7m-come-estrarre-il-contenuto/

### Fattura PA

- https://it.wikipedia.org/wiki/Fattura_elettronica
- https://www.fatturapa.gov.it/export/fatturazione/it/index.htm
- https://www.fatturapa.gov.it/export/fatturazione/it/normativa/f-2.htm
- https://www.fatturapa.gov.it/export/fatturazione/sdi/Specifiche_tecniche_del_formato_FatturaPA_v1.2.1.pdf
- https://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2.1/Schema_del_file_xml_FatturaPA_versione_1.2.1.xsd

### PKCS #7

- [RFC2315](https://tools.ietf.org/html/rfc2315)

## License

TODO
