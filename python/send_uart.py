"""Kirim 73 byte (9 kernel + 64 piksel) ke FPGA lewat UART 8N1.

Contoh:
    python send_uart.py --port COM3
    python send_uart.py --port /dev/ttyUSB0 --file out/test_vector.txt
    python send_uart.py --dry-run          # hanya cetak byte, tanpa port serial

Butuh: pip install pyserial numpy
"""
import argparse
import os
import time

BAUD = 115200
HERE = os.path.dirname(__file__)


def load(path):
    with open(path) as f:
        data = [int(x) for x in f.read().split()]
    if len(data) != 73 or any(not 0 <= b <= 255 for b in data):
        raise SystemExit(f"File harus berisi 73 bilangan 0-255, ditemukan {len(data)}.")
    return bytes(data)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", help="contoh: COM3 atau /dev/ttyUSB0")
    ap.add_argument("--baud", type=int, default=BAUD)
    ap.add_argument("--file", default=os.path.join(HERE, "out", "test_vector.txt"))
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()

    data = load(a.file)
    print(f"Kernel (9 byte): {list(data[:9])}")
    print(f"Piksel (64 byte): {list(data[9:])}")
    if a.dry_run:
        print("Dry run: tidak ada yang dikirim.")
        return
    if not a.port:
        raise SystemExit("Isi --port, atau pakai --dry-run.")

    import serial  # pyserial
    with serial.Serial(a.port, a.baud, bytesize=8, parity="N", stopbits=1, timeout=1) as s:
        for b in data:
            s.write(bytes([b]))
            s.flush()
        time.sleep(0.05)
    print("Terkirim 73 byte. Bandingkan tampilan FPGA dengan python/out/expected.txt")


if __name__ == "__main__":
    main()
