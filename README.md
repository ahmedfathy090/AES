<div align = "center" >    
# AES: ADVANCED ENCRYPTION STANDARD 🔐
</div>

This project provides a Verilog implementation of the Advanced Encryption Standard (AES) algorithm as a part of our Advanced Logic Design course.
![1686899357412](https://github.com/ahmedfathy090/AES/assets/137416623/91c70bd3-e723-4a2e-9117-4a4a921976db)

## Project Overview:
The cipher.v module implements the core AES algorithm. It performs the following steps:

- Initial Round: Takes the plain text as input.
- Key Schedule: Expands the provided key into round keys using a specific algorithm (not included in this base code).
- Multiple Rounds: Iterates through a defined number of rounds, performing the following operations in each round:
- AddRoundKey: XORs the current state with the round key.
- SubBytes: Substitutes each byte in the state with a predefined value (requires sub_bytes.v).
- ShiftRows: Cyclically shifts the rows of the state (requires shift_rows.v).
- MixColumns: Applies a specific linear transformation to the state columns (requires mix_columns.v).
- Final Round: Similar to the regular rounds but skips the MixColumns step.
- Output: The final state after all rounds is the encrypted text.

### Customization:
> The `Nk` and `Nr` parameters in cipher.v control the key size (Nk words) and number of rounds (Nr = Nk + 6).
> You can modify the data width (currently 128 bits) by adjusting the wire sizes throughout the code.
