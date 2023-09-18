module UsersHelper
  def whatsapp_number(user)
    phone = user.whatsapp

    phone.gsub!("+", "")
    phone.gsub!("-", "")
    phone.gsub!("(", "")
    phone.gsub!(")", "")
    phone.gsub!(" ", "")

    while phone.starts_with?("0") do
      phone = phone[1..-1]
    end

    phone
  end

  def whatsapp_link(user)
    "https://wa.me/#{whatsapp_number(user)}"
  end
end
