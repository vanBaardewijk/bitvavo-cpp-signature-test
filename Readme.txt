# Bitvavo C++ HMAC Signature Test

This project demonstrates a **C++ HMAC SHA256 signature mismatch** when calling the Bitvavo API, despite identical signing logic working flawlessly in Python and on other exchanges like Kraken.

## Issue Summary

- C++ HMAC logic works perfectly on **Kraken**
- Python HMAC logic works perfectly on **Bitvavo**
- C++ HMAC logic **fails on Bitvavo**, despite generating the same base64 HMAC signature

We strongly suspect Bitvavo's backend rejects the request based on subtle implementation or formatting differences — possibly involving newline characters, timestamps, or headers.

---

## 📁 Included Files

| File | Description |
|------|-------------|
| `cpp_signature_test.cpp` | C++ code that generates and submits a Bitvavo API request using HMAC |
| `python_signature_test.py` | Working Python equivalent using `hmac` and `requests` |
| `pre_sign_reference.txt` | Raw string used for signing (`timestamp + method + endpoint + body`) |
| `signatures_compare.txt` | C++ vs Python signature output (base64) |
| `bitvavo_response.txt` | Bitvavo's HTTP 401 response (`invalid signature`) |
| `notes.md` | Summary of testing done, suspected issues, and cross-comparison with Kraken |

---

## 🧪 Kraken Comparison

To rule out general implementation bugs, we ran the same C++ signing logic on Kraken's API.

- HMAC signatures **were accepted** by Kraken's backend using the same `crypto++` library
- Bitvavo rejects these exact signatures, even when the `pre_sign` input is byte-for-byte identical

---

## Why This Matters

Bitvavo has **no official C++ SDK**, and current C++ integrations are blocked due to this signature mismatch. This repo may help others debug or reverse-engineer what Bitvavo expects.

---

## Request for Help

If you work at Bitvavo or have experience with:
- Signature verification bugs
- API header formatting issues
- Known Bitvavo HMAC edge cases

Please open an [issue](https://github.com/vanBaardewijk/bitvavo-cpp-signature-test/issues) or pull request.

---

## Related Threads

Coming soon: links to GitHub Issues, Reddit threads, Bitvavo support tickets, or X (Twitter) posts.

---

## License

MIT — share, fork, and contribute freely.
