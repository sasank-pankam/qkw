name:           qkw
version:        {{version}}
release:        1%{?dist}
summary:        generalizing aliasing to simplify navigation, annotate cli commands, add help-strings

license:        gnu
buildarch:      x86_64
url:            https://github.com/sasank-pankam/qkw
Requires:       sqlite >= 3.5.9

%description

%install
mkdir -p %{buildroot}/usr/bin
install -m 0755 %{_sourcedir}/qkw %{buildroot}/usr/bin/qkw # copy the bin to rpmbuild/build dir 

mkdir -p %{buildroot}/etc/qkw-config/
install -m 0644 %{_sourcedir}/qkw-config.yaml %{buildroot}/etc/qkw-config/qkw-config.yaml
install -m 0644 %{_sourcedir}/userdata.db %{buildroot}/etc/qkw-config/userdata.db


mkdir -p %{buildroot}/usr/share/man/man1/
install -m 0644 %{_sourcedir}/qkw.1.gz %{buildroot}/usr/share/man/man1/qkw.1.gz

%files
/usr/bin/qkw
/etc/qkw-config/qkw-config.yaml
/etc/qkw-config/userdata.db
/usr/share/man/man1/qkw.1.gz

%changelog
* fri may 19 2025 you <sasaankme@gmail.com> - 1.0.0
- initial release
