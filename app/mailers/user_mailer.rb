class UserMailer < ActionMailer::Base

  default :from => "noreply@sqopen.com"

  def buy(options={})
    @options = options
    _to = YAML.load(IO.read("#{Rails.root}/config/mail.yml"))['receiver']
    _subject = "#{options['email']} buy plan #{options['plan']}"
    mail(:to => _to ,:subject => _subject)
  end

  def send_message(options={})
    @options = options
    _to = YAML.load(IO.read("#{Rails.root}/config/mail.yml"))['receiver']
    _subject = "#{options['email']} send a message to u"
    mail(:to => _to ,:subject => _subject)
  end

end