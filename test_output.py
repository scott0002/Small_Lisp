import subprocess

def ans(path, result1 = None):
    if not result1:
        cmd = f"./smli < {path}" 
        result1 = subprocess.check_output(cmd, shell=True).decode()
    cmd = f" sh y_compile.sh < {path}" # 改成你的 CMD 執行方式
    result2 = subprocess.check_output(cmd, shell=True).decode()
    assert result1 == result2

def test_1_1():
    ans("test_data/01_1.lsp", "syntax error\n")

def test_1_2():
    ans("test_data/01_2.lsp", "syntax error\n")

def test_2_1():
    ans("test_data/02_1.lsp")

def test_2_2():
    ans("test_data/02_2.lsp")

def test_3_1():
    ans("test_data/03_1.lsp")

def test_3_2():
    ans("test_data/03_2.lsp")

def test_4_1():
    ans("test_data/04_1.lsp")

def test_4_2():
    ans("test_data/04_2.lsp")

def test_5_1():
    ans("test_data/05_1.lsp")

def test_5_2():
    ans("test_data/05_2.lsp")

def test_6_1():
    ans("test_data/06_1.lsp")

def test_6_2():
    ans("test_data/06_2.lsp")

def test_7_1():
    ans("test_data/07_1.lsp", "4\n9\n")

def test_7_2():
    ans("test_data/07_2.lsp", "610\n0\n")

def test_8_1():
    ans("test_data/08_1.lsp", "91\n")

def test_8_2():
    ans("test_data/08_2.lsp", "3\n")

def test_b1_1():
    ans("test_data/b1_1.lsp", "2\n6\n24\n3628800\n1\n2\n5\n55\n6765\n")

def test_b1_2():
    ans("test_data/b1_2.lsp", "4\n2\n27\n")

def test_b2_1():
    ans("test_data/b2_1.lsp", "Type Error: Expect 'number' but got 'boolean'!\n")

def test_b2_2():
    ans("test_data/b2_2.lsp", "Type Error: Expect 'number' but got 'boolean'!\n")

def test_b3_1():
    ans("test_data/b3_1.lsp", "25\n")

def test_b3_2():
    ans("test_data/b3_2.lsp", "9\n8\n")

def test_b4_1():
    ans("test_data/b4_1.lsp", "11\n")

def test_b4_2():
    ans("test_data/b4_2.lsp", "9\n")
