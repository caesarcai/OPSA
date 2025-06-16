# OPSA
This repo is for our 2025 ICML paper "[Guarantees of a Preconditioned Subgradient Algorithm for Overparameterized Asymmetric Low-rank Matrix Recovery](https://openreview.net/forum?id=GaCo82yC7z)". 

## Environment
Matlab 2020a and later.

## Examples

Run `test_OPSA_diff_kappa.m` to test OPSA with different condition numbers. Therein, you can find an example to call the OPSA algorithm.

Run `test_mixed_norm_RIP.m` to test the mixed norm RIP for Gaussian measurements. This test doesn't involve the OPSA algorithm.

## Recommended citation
If you find this code useful, please use the following citation:
```
@inproceedings{giampouras2025opsa,
  title     = {Guarantees of a Preconditioned Subgradient Algorithm for Overparameterized Asymmetric Low-rank Matrix Recovery},
  author    = {Giampouras, Paris and Cai, HanQin and Vidal, Ren\'e},
  booktitle = {International Conference on Machine Learning},
  year      = {2025}
}
```
