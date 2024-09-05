
# 📦 Restic ve Docker Kullanarak Yedekleme Otomasyonu

Bu proje, GitHub repolarını Amazon S3'e yedeklemek için Restic ve Docker kullanarak otomasyonu sağlar. Yedeklerin **dosya** olarak mı yoksa disk alanı verimliliği için **geçici hafızada** mı saklanacağını seçmenize olanak tanır. Proje, verilerin güvenliğini sağlamak için şifreleme sunar ve kullanıcılar için çeşitli özelleştirmeler sunar.

## 🚀 Özellikler
- **Otomatik GitHub Yedekleme**: Belirli aralıklarla repoları S3'e yedekler.
- **Docker ile Entegre Kurulum**: İzole bir ortamda sorunsuz çalışır.
- **Restic Entegrasyonu**: Şifreli ve verimli yedeklemeler sağlar.
- **Esnek Depolama**: Yedeklerin dosya olarak mı yoksa geçici bellekte mi saklanacağını seçebilirsiniz.
- **Ortam Değişkenleri ile Konfigürasyon**: Kolayca özelleştirilebilir.

## 📋 Gereksinimler
- Docker'ın sisteminizde kurulu olması.
- Yedeklerin saklanacağı bir Amazon S3 bucket'ı.
- GitHub API token'ı.

## 🔧 Kurulum ve Ayarlar

### Adım 1: Repoyu Klonlayın
```bash
git clone https://github.com/yourusername/backup-automation
cd backup-automation
```

### Adım 2: Ortam Değişkenlerini Ayarlayın
Gerekli kimlik bilgilerini `.env` dosyasında doldurduğunuzdan emin olun. Güvenlik amacıyla, **BU DOSYALARI** herkese açık olarak paylaşmayın.

```env
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
RESTIC_PASSWORD=your-restic-password
GITHUB_TOKEN=your-github-token
```

### Adım 3: Docker İmajını Oluşturun
```bash
docker build -t restic-backup .
```

### Adım 4: Docker Container'ı Çalıştırın
Yedekleme işlemini başlatmak için aşağıdaki komutu çalıştırabilirsiniz:
```bash
docker run --env-file=config.env restic-backup
```

## 📂 Konfigürasyon
- `config.env`: AWS kimlik bilgileri, GitHub token'ı ve Restic şifresi gibi ortam değişkenlerini içerir.
- `secrets.env`: Bu dosyanın doğru şekilde **korunduğundan** emin olun. Hassas veriler içerir ve asla GitHub'a yüklenmemelidir.

**Önemli**: Yedeklerin dosya olarak mı yoksa geçici bellekte mi saklanacağını ayarlayabilirsiniz. Bellekte saklamak, disk alanı tasarrufu sağlar ve verimliliği artırır.

## 🛠 Restic Kurulumu

Eğer Docker kullanmak istemiyorsanız, **Restic**'i şu adımlarla kurabilirsiniz:

```bash
# Linux sistemler için:
sudo apt update
sudo apt install restic

# macOS sistemler için:
brew install restic
```

Kurulumdan sonra Restic'i şu şekilde başlatabilirsiniz:
```bash
restic -r s3:s3.amazonaws.com/your-bucket-name init
```

## 🔄 Yedekleme ve Geri Yükleme Örnekleri

### Bir Reponun Yedeklenmesi
```bash
restic -r s3:s3.amazonaws.com/your-bucket-name backup /path/to/repo
```

### Yedekten Geri Yükleme
```bash
restic -r s3:s3.amazonaws.com/your-bucket-name restore latest --target /restore/path
```

## 🧹 Disk Alanı Tasarrufu
Disk alanı tasarrufu sağlamak için yedekleri **geçici bellekte** saklayabilirsiniz. Bu, özellikle büyük veri kümeleri ile çalışırken depolama alanı sınırlı olduğunda iyi bir seçenektir.

## 🔐 Güvenlik Dikkatleri
- **Şifreleme**: Tüm yedekler Restic kullanılarak şifrelenir, böylece veriler korunmuş olur.
- **Ortam Değişkenleri**: AWS anahtarlarınız ve GitHub token gibi hassas bilgilerin güvenli bir şekilde saklandığından emin olun ve bu bilgileri herkese açık depolarda paylaşmayın.

## 📚 Kaynaklar
- [Restic Belgeleri](https://restic.readthedocs.io/en/stable/)
- [Docker Belgeleri](https://docs.docker.com/)
- [Amazon S3 Kurulumu](https://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html)

## 💡 Ek Notlar
- Bu proje, ihtiyacınıza göre farklı yedekleme stratejilerini destekleyecek şekilde esneklik sağlar.
- Bu projeyi Kubernetes veya başka bir bulut sağlayıcısında çalıştırıyorsanız, uygun IAM rolleri ve güvenlik politikalarının yerinde olduğundan emin olun.


# Jenkins Pipeline Kullanımı

Bu Jenkinsfile, Docker Hub'dan bir Docker image çekme, çalıştırma ve başarısızlık durumunda e-posta bildirimi gönderme işlemlerini otomatikleştirir. Pipeline, her 12 saatte bir çalışacak şekilde ayarlanmıştır.

## Adımlar

### 1. Jenkinsfile'ı Projeye Ekleyin
Bu repository'deki Jenkinsfile'ı projenizin kök dizinine ekleyin.

### 2. Docker Hub Kimlik Bilgilerini Yapılandırın
Jenkins üzerinde Docker Hub kimlik bilgilerinizi yapılandırmanız gerekmektedir. Şu adımları izleyin:
1. Jenkins Dashboard'a gidin.
2. **Manage Jenkins** > **Credentials** > **System** > **Global credentials (unrestricted)** kısmına gidin.
3. Yeni kimlik bilgisi ekleyin ve kullanıcı adı/şifre ile **ID**'yi `dockerhub-credentials` olarak ayarlayın.

### 3. Jenkins Job'ı Oluşturun
1. Jenkins arayüzünde yeni bir **pipeline** job'ı oluşturun.
2. Kaynak kodunu GitHub gibi bir repository'den çekebilirsiniz.
3. **Build Triggers** kısmında **Build periodically** seçeneğini seçin ve aşağıdaki cron ifadesini girin:
   ```bash
   H */12 * * *

   Bu ifade, job’ı her 12 saatte bir çalıştıracaktır.
4. Pipeline kısmında, Jenkins’in doğru Jenkinsfile yoluna (örneğin, GitHub repository’sindeki Jenkinsfile) yönlendirilmesini sağlayın.

4. Job’ı Çalıştırın

Jenkins job’ını oluşturduktan sonra, job’ı manuel olarak çalıştırabilir ya da her 12 saatte bir otomatik olarak çalıştırılmasını sağlayabilirsiniz. Docker Hub’dan çekmek istediğiniz Docker image URL’sini parametre olarak verebilirsiniz.

### Parametreler

	•DOCKER_IMAGE: Jenkins job’ı çalıştırılırken Docker Hub’dan çekilecek image URL’si (örn: username/repository:tag). Job’ı tetiklerken bu parametre girilmelidir.

### Otomatik Çalıştırma

Pipeline, her 12 saatte bir otomatik olarak çalışacak şekilde ayarlanmıştır. Eğer job başarısız olursa, belirttiğiniz e-posta adresine bir bildirim gönderilecektir.

### Hata Bildirimi

Pipeline başarısız olursa, you@example.com adresine bir hata maili gönderilecektir. Hatanın detayları için Jenkins konsolunu kontrol edebilirsiniz.


# Kubernetes CronJob ve Secret Kurulum Kılavuzu

Bu kılavuz, her 12 saatte bir çalışan ve ortam değişkenlerini yönetmek için bir Kubernetes Secret kullanan bir Kubernetes CronJob'un nasıl kurulacağını açıklar.

## Gereksinimler

- Kubernetes cluster'ı aktif ve çalışıyor olmalıdır.
- kubectl, cluster ile etkileşim kuracak şekilde yapılandırılmalıdır.
- Docker imajınız Docker Hub'a (veya başka bir registry'ye) yüklenmiş olmalıdır.

## Dağıtım Adımları

### 1. Kubernetes Secret Oluşturma

İlk olarak, ortam değişkenlerini güvenli bir şekilde saklamak için bir Kubernetes Secret oluşturmamız gerekiyor. Secret değerlerinin base64 formatında olduğundan emin olun.

#### Örnek: Secret Değerini Base64 Formatına Çevirme

Secret değerlerini base64 formatına çevirmek için şu komutu kullanın:

```bash
echo -n 'gizli-değeriniz' | base64
```

#### Secret YAML Dosyası (`secret.yaml`)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: docker-env-secrets
type: Opaque
data:
  ORNEK_KEY: c2VjcmV0LXZhbHVl # Base64 formatında şifrelenmiş örnek secret değeri
  BASKA_KEY: YW5vdGhlci12YWx1ZQ== # Başka bir örnek secret değeri
```

Secret'ı uygulamak için şu komutu çalıştırın:

```bash
kubectl apply -f secret.yaml
```

### 2. Kubernetes CronJob Oluşturma

Bir sonraki adımda, her 12 saatte bir çalışacak ve Docker Hub'dan bir Docker imajı çekecek bir Kubernetes CronJob oluşturuyoruz. CronJob, daha önce oluşturduğumuz Secret'ı kullanacaktır.

#### CronJob YAML Dosyası (`cronjob.yaml`)

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: docker-image-cronjob
spec:
  schedule: "0 */12 * * *"  # Job her 12 saatte bir çalışacak
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: docker-image-job
            image: <DOCKER_HUB_IMAGE_URL>  # Docker Hub imaj URL'nizi buraya yazın
            envFrom:
              - secretRef:
                  name: docker-env-secrets  # Daha önce oluşturulan Secret burada kullanılıyor
            command: ["/bin/sh", "-c", "bash /mnt/data/backup.sh && echo Job Completed"]
          restartPolicy: OnFailure
```

CronJob'u uygulamak için şu komutu çalıştırın:

```bash
kubectl apply -f cronjob.yaml
```

### 3. CronJob'u İzleme

CronJob'un düzgün çalıştığını, durumunu ve oluşturduğu job'ları kontrol ederek doğrulayabilirsiniz.

#### CronJob Durumunu Kontrol Etme

```bash
kubectl get cronjob
```

#### Çalışan Job'ları Kontrol Etme

```bash
kubectl get jobs
```

#### Pod Loglarını Görüntüleme

Belirli bir pod'un loglarını görüntülemek için (gerçek pod adı yerine `<pod-name>` yazın):

```bash
kubectl logs <pod-name>
```

### 4. Sonuç

Artık her 12 saatte bir çalışan ve Docker Hub'dan bir Docker imajı çeken, ortam değişkenlerini Kubernetes Secret ile yöneten bir Kubernetes CronJob kurulumunu tamamladınız.

---

## Dosyalar

- `secret.yaml`: Ortam değişkenlerini yönetmek için Kubernetes Secret'ı tanımlar.
- `cronjob.yaml`: Docker container'ını çalıştıran Kubernetes CronJob'u tanımlar.

Her iki dosyanın da cluster'a `kubectl apply` komutu ile uygulandığından emin olun.



# Kullanıcı Sorumluluğu Beyanı

Bu proje, kullanıcının kullanımına sunulmuştur ve kullanımı tamamen kullanıcının sorumluluğundadır. Kullanıcı, bu proje veya bileşenlerinin kullanımı sırasında oluşabilecek herhangi bir veri kaybı, sistem hatası, güvenlik açığı veya diğer olumsuz sonuçlardan sorumludur. Proje geliştiricisi, kullanıcının bu projeyi kullanması sonucunda meydana gelebilecek doğrudan veya dolaylı zararlardan hiçbir şekilde sorumlu tutulamaz.

Kullanıcı, projeyi kullanmadan önce aşağıdaki sorumlulukları kabul eder:

1. **Güvenlik ve Gizlilik**: Kullanıcı, projeyi kullanırken ilgili güvenlik ve gizlilik protokollerine uygun hareket etmekle yükümlüdür. Gizli bilgilerin (örneğin, şifreler, API anahtarları, vb.) yanlışlıkla açığa çıkmaması için gerekli tüm önlemleri almalıdır.

2. **Veri Yedekleme**: Kullanıcı, projeyi kullanmadan önce gerekli veri yedeklemelerini yapmakla yükümlüdür. Veri kaybı durumunda geliştirici sorumlu tutulamaz.

3. **Yasal Uyum**: Kullanıcı, bu projeyi kullanırken geçerli yasal düzenlemelere, özellikle veri koruma ve gizlilik yasalarına uymak zorundadır.

4. **Sistem Kaynakları**: Kullanıcı, bu projeyi kullanırken sistem kaynaklarının doğru yönetilmesi ve projeyi kullanmanın sistemi olumsuz etkilemeyecek şekilde yapılandırılması sorumluluğunu kabul eder.

5. **Üçüncü Taraf Bileşenler**: Proje, üçüncü taraf kütüphaneler veya hizmetler ile entegre olabilir. Kullanıcı, bu üçüncü taraf bileşenlerin kullanımından doğabilecek sorunlardan sorumludur ve ilgili hizmetlerin kullanım koşullarını kabul etmiş sayılır.

Kullanıcı, projeyi kullanarak yukarıda belirtilen tüm sorumlulukları kabul eder ve projeyle ilgili oluşabilecek herhangi bir problemden geliştiricinin sorumlu tutulamayacağını beyan eder.