# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       harbour-biddy-bff

# >> macros
# << macros

Summary:    Boolean functions forever
Version:    0.9
Release:    4
Group:      Qt/Qt
License:    GPLv2
URL:        https://biddy.meolic.com/
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-biddy-bff.yaml
Requires:   sailfishsilica-qt5
BuildRequires:  pkgconfig(sailfishapp)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
A tool for minimization of Boolean functions.

# This description section includes metadata for SailfishOS:Chum, see
# https://github.com/sailfishos-chum/main/blob/main/Metadata.md
%if 0%{?_chum}
Title: BFF
Type: desktop-application
DeveloperName: meolic
Categories:
 - Other
Custom:
  Repo: https://github.com/meolic/harbour-biddy-bff
PackageIcon: https://github.com/meolic/harbour-biddy-bff/raw/main/icons/172x172/harbour-biddy-bff.png
Screenshots:
 - https://github.com/meolic/harbour-biddy-bff/raw/main/screenshots/screenshot1.png
 - https://github.com/meolic/harbour-biddy-bff/raw/main/screenshots/screenshot2.png
 - https://github.com/meolic/harbour-biddy-bff/raw/main/screenshots/screenshot3.png
Links:
  Homepage: https://biddy.meolic.com/
  Help: https://github.com/meolic/harbour-biddy-bff/discussions
  Bugtracker: https://github.com/meolic/harbour-biddy-bff/issues
  Donation: https://liberapay.com/meolic/donate
%endif

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/*
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files

%changelog
