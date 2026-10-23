# Gün 01 — Linux sağlık raporu

Süre hedefi: 60–90 dakika. Amaç mevcut seviyeyi uygulamayla görmek.

## Problem

Bir sunucunun disk durumunu her seferinde elle incelemek yerine küçük bir Bash
aracıyla raporlamak ve disk doluluğunda başarısız çıkış kodu üretmek istiyoruz.
Çıkış kodu ileride başka scriptlerin ve CI süreçlerinin sonucu kullanmasını sağlayacak.

## 1. Ortamı ve ham çıktıları incele — 15 dakika

Ubuntu terminalinde komutları tek tek çalıştır:

```bash
cat /etc/os-release
bash --version
git --version
df -P /
free -m
```

Şu üç noktayı kendi cümlelerinle açıkla:

1. `df -P /` hangi dosya sistemini raporluyor?
2. `free -m` çıktısında `free` ile `available` neden aynı değil?
3. Bir scriptte ekrana hata yazmak ile sıfırdan farklı çıkış kodu döndürmek arasındaki fark ne?

Not: WSL içindeki kök dosya sisteminin doluluğu, Windows C: sürücüsünün doluluğuyla
aynı ölçüm değildir. Bu görev yalnızca Linux kök dosya sistemini kontrol eder.

## 2. Scripti yaz — 35–50 dakika

`scripts/health-check.sh` dosyasını sen oluştur.

İlk sürümün sözleşmesi:

- Bash üzerinde çalışır.
- Tarih/saat, makine adı, `/` dosya sisteminin doluluk yüzdesini ve bellek bilgisini gösterir.
- Bellekte toplam, kullanılan ve kullanılabilir miktarları MiB olarak etiketler.
- İsteğe bağlı ilk argüman disk eşiğidir; verilmezse `80` kullanılır.
- Eşik için yalnızca 1–100 arasındaki tam sayıları kabul eder; başında sıfır olan çok basamaklı girdileri reddedebilir.
- Birden fazla argümanı veya geçersiz eşiği açıklayıcı mesajla reddeder.
- Disk doluluğu eşiğe eşit veya daha büyükse `WARNING` ve çıkış kodu `1` üretir.
- Disk doluluğu eşikten küçükse `OK` ve çıkış kodu `0` üretir.
- Argüman hatasında standart hata akışını ve çıkış kodu `2` kullanır.
- Gerekli bir ölçüm komutu başarısız olursa `OK` yazmaz; standart hataya açıklama yazar ve çıkış kodu `3` döndürür.
- Sistem ayarlarını değiştirmez ve dosya silmez.

Henüz servis kontrolü, alarm gönderme veya Docker ekleme.

İpuçları: `date`, `hostname`, `df -P /`, `free -m`, `awk`, `if`, `>&2`, `exit`.
Ham çıktıları önce anla; sonra ihtiyacın olan alanları çıkar.

## 3. Davranışı doğrula — 15 dakika

Komutları ayrı ayrı çalıştır; her çağrıdan hemen sonra çıkış kodunu oku:

```bash
bash -n scripts/health-check.sh

bash scripts/health-check.sh
echo $?

bash scripts/health-check.sh 1
echo $?

bash scripts/health-check.sh 100
echo $?

bash scripts/health-check.sh abc
echo $?

bash scripts/health-check.sh 101
echo $?

bash scripts/health-check.sh 80 extra
echo $?
```

`bash -n` yalnızca sözdizimini kontrol eder. Varsayılan, `1` ve `100` eşiğinin
sonucu gerçek disk doluluğuna bağlıdır; `df -P /` ile karşılaştır.
Son üç çağrı argüman hatası nedeniyle `2` döndürmelidir.

Diski doldurarak deneme yapma. Daha sonraki görevde örnek ölçüm verisiyle sınır
durumlarını, komut hatalarını ve `1` çıkışını güvenilir biçimde doğrulayacağız.

## 4. Not ve commit — 10 dakika

`docs/learning-log.md` dosyasında şu soruları cevapla:

- Bugün ne öğrendim?
- Nerede takıldım ve nasıl çözdüm?
- Hangi girdileri denedim, hangi çıktıları ve çıkış kodlarını aldım?
- Sonraki küçük adım ne?

Gerçek çıktıları kaydet; henüz uygulamadığın özelliği tamamlandı diye işaretleme.

Repo henüz başlatılmadıysa proje klasöründe:

```bash
git init -b main
git status
```

Git kimliğini kontrol et. Windows'taki ayarlar WSL içinde otomatik olarak
kullanılmayabilir. E-posta adresinin commit geçmişinde görüneceğini dikkate al;
istersen GitHub hesabındaki noreply adresini kullan.

Dosyaları inceleyip ilk commitini oluştur:

```bash
git add README.md .gitignore .gitattributes scripts docs
git diff --cached
git commit -m "feat: add initial Linux health report"
```

GitHub'a yükleme adımında depo adını, erişimini ve kimlik doğrulamayı birlikte
kontrol edeceğiz. Kimlik doğrulama için token veya şifreni sohbete yazma.

## Birlikte inceleme

Scriptini, denediğin komutların çıktılarını ve üç kısa cevabını paylaş.
Önce mantığı ve hata durumlarını inceleyeceğiz; sonraki görevini buna göre seçeceğiz.
