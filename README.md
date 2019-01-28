## get_fattura_pa

The purpose of this script is exclusively to read invoices received from the
"Sistema di Interscambio".

## Definitions

| Term | Meaning |
|------|---------|
| signed file | the invoice file signed with a PCKS-7 public key |
| metadata file | a file that contains the checksum of the signed file as well as other information |
| original file | the invoice file without the signature |
| attachments | 

## Pipeline

1. check script dependencies
2. check signed file hash given the metadata file. "${metadata_file}" 
3. get certificates from the government website and transform them in a readable format for OpenSSL
4. check signature of signed file
5. extract the original file from the signed file 
6. decode possible attachments from the original file

### Usual pipeline

    1 -> 2 -> 3 -> 4 -> 5 -> 6

### Shot pipeline

Most of the steps are optional, however I strongly advise you to check the 
hash and signature.

    1 -> 5

## Resources

- https://www.fatturapa.gov.it/export/fatturazione/it/index.htm
- https://www.fatturapa.gov.it/export/fatturazione/sdi/Specifiche_tecniche_del_formato_FatturaPA_v1.2.1.pdf

## License

TODO
