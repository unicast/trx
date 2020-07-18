-include .config

INSTALL ?= install

# Installation paths

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

CFLAGS += -MMD -Wall

LDLIBS_ASOUND ?= -lasound
LDLIBS_OPUS ?= -lopus
LDLIBS_ORTP ?= -lortp

LDLIBS += $(LDLIBS_ASOUND) $(LDLIBS_OPUS) $(LDLIBS_ORTP)

.PHONY:		all install dist clean

all:		rx tx

rx:		rx.o device.o sched.o

tx:		tx.o device.o sched.o

install:	rx tx
		$(INSTALL) -d $(DESTDIR)$(BINDIR)
		$(INSTALL) rx tx $(DESTDIR)$(BINDIR)

install-deb-deps:
		apt-get udpate
		apt-get install -y build-essential libasound2-dev libopus-dev libortp-dev

dist:
		mkdir -p dist
		V=$$(git describe) && \
		git archive --prefix="trx-$$V/" HEAD | \
			gzip > "dist/trx-$$V.tar.gz"

clean:
		rm -f *.o *.d tx rx

-include *.d
