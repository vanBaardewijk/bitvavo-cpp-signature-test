# Bitvavo C++ HMAC Signature Test

This project demonstrates a signature mismatch issue when accessing the Bitvavo API using C++ HMAC signing. The same logic works in Python and with other exchanges like Kraken.

## Included Files

- `cpp_signature_test.cpp` – C++ code that generates HMAC signature for Bitvavo
- `python_signature_test.py` – Reference Python version with correct result
- `pre_sign_reference.txt` – Raw string used for signing
- `signatures_compare.txt` – Comparison of C++ vs Python results
- `bitvavo_response.txt` – Bitvavo error response for invalid signature
- `notes.md` – Investigation notes and technical analysis

## Result Summary

-  Python signature accepted
-  C++ signature rejected (even when identical HMAC result)
-  Same C++ logic works on Kraken, implying Bitvavo-specific validation logic

---

### Can You Help?

We’re trying to identify what Bitvavo expects differently in their HMAC request handling.

If you spot something, feel free to open an issue or pull request.