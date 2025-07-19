# Bitvavo C++ HMAC Signature Mismatch

## Summary

This repository demonstrates a signature mismatch when calling the Bitvavo `/v2/account` endpoint using C++. The same HMAC-SHA256 signing logic works in Python but fails in C++, despite using identical pre-sign strings, timestamps, and credentials.

## Files

- `python_signature_test.py`: Working Python example (returns 200 OK)
- `cpp_signature_test.cpp`: Failing C++ version (returns 403 Forbidden)
- `pre_sign_reference.txt`: Exact pre-sign string and timestamp used in tests
- `signatures_compare.txt`: HMAC output from both implementations
- `bitvavo_response.txt`: Full API response from Bitvavo after the C++ call
- `kraken_test.cpp`: C++ Kraken HMAC example (used for comparison)
- `kraken_response.txt`: Verified success response from Kraken
- `notes.md`: This file (summary and draft for reporting)

## Test Details

- **Endpoint**: `GET /v2/account`
- **Pre-sign string**: `1752808890747GET/v2/account`
- **Expected signature (Python)**: `35fad2ddd37c6c459410ee1e4e89a26e9f127f1ea791d189298fc0ede80c2643`
- **C++ result**: Signature differs — API returns HTTP 403 with:
  > `"The signature is invalid."`

## What We’re Asking

Bitvavo support has confirmed that the API key and permissions are valid. We’re seeking guidance to understand **why the C++ HMAC signature fails**, even though all inputs match the Python version.

### Specifically:
- Can Bitvavo confirm the correct HMAC signature for the pre-sign string above?
- Are there any encoding rules (e.g., newline normalization, null terminators, charset assumptions) that might differ between platforms?
- Are there known quirks in how headers must be structured for Bitvavo signature verification?

---

## Additional Context: Kraken Comparison

To eliminate the possibility of a bug in our C++ HMAC logic, we tested it with Kraken’s REST API.

- **Endpoint**: `POST /0/private/Balance`
- **Signature method**: HMAC-SHA512 using OpenSSL
- **Result**: **200 OK** — Kraken accepted the C++-generated signature.

This confirms our C++ signature generation is valid and production-grade.

We’re publishing this issue to help other C++ developers integrating with Bitvavo’s API and would appreciate any insight the Bitvavo team can share.

—
Sascha

---

## 🔍 Update: Fixed Timestamp & Cross-Language Signature Verification (July 19, 2025)

We generated a deterministic test using the fixed timestamp `1752892051047` and pre-sign string:

## 📨 Support Interaction Summary

- July 18: Reproducible issue submitted to Bitvavo support
- July 19: Support from Bitvavo replied:  
  _“Thanks for the information. I understand the frustration. Let me look into this further and see if there is anything wrong with our HMAC signature mechanisms.”_

We’re awaiting a deeper technical response or escalation.

---

### Signature Results (all match):

- **Python**: `c20086429974ff9ebce01805c7561ec9dfb4f1addc7ec367f3fa2e8a2f1f7411`
- **C++ (OpenSSL)**: `c20086429974ff9ebce01805c7561ec9dfb4f1addc7ec367f3fa2e8a2f1f7411`
- **curl (custom header injection)**: `c20086429974ff9ebce01805c7561ec9dfb4f1addc7ec367f3fa2e8a2f1f7411`

### Bitvavo API Response:
```json
403 {"errorCode":309,"error":"The signature is invalid."}
