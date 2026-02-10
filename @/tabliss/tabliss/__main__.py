from tabliss.boilerplate import Config, google_sheet as sheet

# https://feathericons.com/

z = Config(fg="#ECECEC", bg="#424242", fg_dim="#777777")
l = z.link

z.new_row()  # =================================================================

l("p.mail", "https://mail.proton.me", icon="mail")
l("outlook", "https://outlook.office365.com/mail/", icon="mail")
l("g.mail", "https://gmail.com", icon="mail")
l("g.drive", "https://drive.google.com", icon="hard-drive")

z.new_row()  # =================================================================

l("calendar", "https://calendar.notion.so", icon="calendar")
l("job.app", sheet("12kmFEuOpieg_fpT5aCUyXpqC954iZ7MbVtZ9Sb0GDFw"), "table")
l("grad.app", "https://gradapp.nus.edu.sg/apply", icon="send")
l("notes", "https://app.standardnotes.com/", icon="file-text")

z.new_row()  # =================================================================

l("lean api", "https://leanprover-community.github.io/mathlib4_docs/", icon="book")
l("dbs", "https://internet-banking.dbs.com.sg", icon="globe")
l("emoji", "https://emoji.julien-marcou.fr/", icon="image")
l("resume", "https://github.com/nguyenvukhang/hire", icon="github")

# ==============================================================================

z.save("tabliss.json")
