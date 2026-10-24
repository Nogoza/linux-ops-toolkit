# Proje 1 — Linux Ops Toolkit v0.1.0

## Çıktı

Linux sistem bilgilerini terminalde raporlayan, disk doluluk eşiğini kontrol eden,
anlamlı çıkış kodları kullanan ve GitHub Actions ile test edilen bir Bash aracı.

## Uygulanan konular

- `df`, `free`, `awk`, pipe, değişkenler ve komut çıktısını yakalama.
- Argüman doğrulama, standart çıktı/hata ve çıkış kodları.
- `pipefail` ve komut başarısızlığını açıkça kontrol etme.
- Alt kabuklarda geçici komutlar tanımlayarak kontrollü hata üretme.
- Beklenen çıkış kodunu ve mesajı doğrulayan otomatik testler.
- 79/80/81 disk örnekleriyle eşik altı, eşitlik ve eşik üstü sınamaları.
- Eski hatalı sürümde testin başarısız olduğunu doğrulama.
- Branch, commit, push, pull request, merge ve GitHub Actions.

## Çözülen somut hata

İlk sürüm, `free` veya `df` başarısız olduğunda yanlışlıkla `OK` ve çıkış kodu 0
üretebiliyordu. Hata yeniden üretildi; `pipefail` ve açık kontroller eklenerek
ölçüm hatalarında çıkış kodu 3 dönmesi sağlandı. Regresyon testleri eski sürümde
başarısız, düzeltilmiş sürümde başarılı oldu.

## Bitiş ölçütleri

- Çalışan sistem raporu ve disk eşiği kontrolü.
- Belgelenmiş kullanım, çıkış kodları ve bilinen sınırlar.
- Beş otomatik test ve başarılı GitHub Actions kontrolleri.
- Değişikliklerin ana dalda birleştirilmesi ve v0.1.0 sürümünün yayımlanması.

Servis kontrolü, yedekleme ve sürekli izleme bu ilk sürümün kapsamına dahil değildir.

## Sonraki proje

Küçük bir API, PostgreSQL ve Docker Compose ile birlikte çalışan servisler
oluşturmak. İlk hedef, uygulamayı ve veritabanını tek komutla başlatabilmek.
