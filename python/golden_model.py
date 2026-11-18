"""Golden model akselerator konvolusi 2D (konvolusi 3x3 -> ReLU + saturasi 0..255 -> max pooling 2x2).

Seluruh operasi memakai bilangan bulat sehingga hasil FPGA harus sama persis (error 0).

Contoh:
    python golden_model.py --seed 1           # citra dan kernel acak, tulis ke python/out/
    python golden_model.py --example          # nilai kecil, hasil bervariasi (cocok untuk demo)
"""
import argparse
import os
import numpy as np

IMG, K = 8, 3


def conv_valid(img, ker):
    """Konvolusi tanpa padding, stride 1: 8x8 -> 6x6. Akumulator bertanda (20 bit di FPGA)."""
    n = IMG - K + 1
    out = np.zeros((n, n), dtype=np.int64)
    for r in range(n):
        for c in range(n):
            out[r, c] = int(np.sum(img[r:r + K, c:c + K].astype(np.int64) * ker.astype(np.int64)))
    return out


def relu_sat(x):
    """ReLU lalu saturasi: negatif -> 0, lebih dari 255 -> 255."""
    return np.clip(x, 0, 255)


def max_pool(fm):
    """Max pooling 2x2 stride 2: 6x6 -> 3x3."""
    n = fm.shape[0] // 2
    out = np.zeros((n, n), dtype=np.int64)
    for p in range(n):
        for q in range(n):
            out[p, q] = fm[2 * p:2 * p + 2, 2 * q:2 * q + 2].max()
    return out


def display_strings(res):
    """Tampilan seven segment: digit kiri = indeks, tiga digit kanan = nilai."""
    return [f"{i}{int(v):03d}" for i, v in enumerate(res.flatten())]


def to_bytes(img, ker):
    """73 byte: 9 byte kernel (komplemen dua, baris demi baris) lalu 64 byte piksel."""
    kb = [int(v) & 0xFF for v in ker.flatten()]
    pb = [int(v) for v in img.flatten()]
    return kb + pb


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--example", action="store_true")
    ap.add_argument("--out", default=os.path.join(os.path.dirname(__file__), "out"))
    a = ap.parse_args()

    if a.example:
        # Nilai kecil agar hasil bervariasi (tidak semua 0 atau 255)
        rng = np.random.default_rng(42)
        img = rng.integers(0, 41, size=(8, 8), dtype=np.int64)
        ker = rng.integers(-1, 3, size=(3, 3), dtype=np.int64)
    else:
        rng = np.random.default_rng(a.seed)
        img = rng.integers(0, 256, size=(8, 8), dtype=np.int64)
        ker = rng.integers(-128, 128, size=(3, 3), dtype=np.int64)

    acc = conv_valid(img, ker)
    fm = relu_sat(acc)
    res = max_pool(fm)

    print("Kernel:\n", ker)
    print("Konvolusi (akumulator):\n", acc)
    print("Peta fitur setelah ReLU+saturasi:\n", fm)
    print("Hasil max pooling 3x3:\n", res)
    print("Tampilan FPGA:", display_strings(res))

    os.makedirs(a.out, exist_ok=True)
    data = to_bytes(img, ker)
    assert len(data) == 73
    with open(os.path.join(a.out, "test_vector.txt"), "w") as f:
        f.write("\n".join(str(b) for b in data) + "\n")
    with open(os.path.join(a.out, "expected.txt"), "w") as f:
        f.write("\n".join(display_strings(res)) + "\n")
    print(f"Ditulis: {a.out}/test_vector.txt (73 byte) dan expected.txt (9 baris)")


if __name__ == "__main__":
    main()
