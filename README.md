<div align="center">
<h1> AES: Advanced Encryption System 🔐</h1> 
</div>
 This repository contains a Verilog implementation of the Advanced Encryption Standard (AES) algorithm, developed as part of a first-year computer engineering course on advanced logic design.
 --------
 ## 🚀Features 
- **Flexible Key Length Support:** Encrypts and decrypts data using 128-bit, 192-bit, or 256-bit keys (depending on your implementation choices).
- **Debugging Assistance:** Provides a log transcript that can be printed during operation to aid in debugging.
- **Verification:** Includes testbenches for thorough verification of encryption and decryption functionality.
---
## 📃Classes structure:

![[Pasted image 20240710201903.png]]

>[image resource](https://www.researchgate.net/figure/The-overall-structure-of-the-AES-algorithm-1_fig1_320162676)

Top-Level Module `AES.v`
- This module serves as the entry point for your AES design.
- It takes inputs such as:
    - Plaintext/Ciphertext data
    - Key
    - Control signals (e.g., encryption/decryption mode, key length selection)
- It instantiates the following sub-modules:
	- `keysGenerator.v` which in turn calls
	- `Cipher.v` which in turn calls Round function modules (e.g., `SubBytes.v`, `ShiftRows.v`, `MixColumns.v`, `AddRoundKey.v`)
	- `InvCipher.v` which in turn calls Inverse Round function modules (e.g., `InvSubBytes.v`, `InvShiftRows.v`, `InvMixColumns.v`, `AddRoundKey.v`)
- It performs the following operations:
	- Selects the appropriate key length depending on the selected mode
	- Loops through the required number of rounds *(based on key length)* by iterating over the round function modules.
	- Provides the final encrypted/decrypted output.
- Implements a log transcript mechanism (using system tasks like `$display` or dedicated logging signals) to print intermediate values for debugging.
---
## 🚧Getting Started
1. Start with cloning the repo
```
git clone https://github.com/ahmedfathy090/AES.git
```
2. Synthesis and Simulation
	- **Install Quartus Prime:** Download and install the Intel Quartus Prime software from the Intel website.
	- [Choose the appropriate version based on your operating system.](https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime.html)
	- **Create** a new project and **add** source files.
	- **Compile** the Design
	- **Run** Simulation
> [!TIP]
> Don't forget to make use of the debugging assistant transcript provided in the code!

----
## 👩🏻‍💻👩🏻‍💻Contributors 🧑🏻‍💻🧑🏻‍💻
<table>
<tr>
  <td align = "center"> 
	<a href = "https://github.com/ahmedfathy0-0">
	  <img src = "https://github.com/ahmedfathy0-0.png" width = 100>
	  <br />
	  <sub> Ahmed Fathy</sub>
	</a>
  </td>
  <td align = "center"> 
	<a href = "https://github.com/habibayman">
	  <img src = "https://github.com/habibayman.png" width = 100>
	  <br />
	  <sub> Habiba Ayman </sub>
	</a>
  </td>
  <td align = "center"> 
	<a href = "https://github.com/Tasneemmohammed0">
	  <img src = "https://github.com/Tasneemmohammed0.png" width = 100>
	  <br />
	  <sub> Tasneem Mohamed </sub>
	</a>
  </td>
  <td align = "center"> 
	<a href = "https://github.com/ahmedGamalEllabban">
	  <img src = "https://github.com/ahmedGamalEllabban.png" width = 100>
	  <br />
	  <sub> Ahmed Gamal </sub>
	</a>
  </td>
</tr>
</table>
