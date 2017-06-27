FROM scratch

ADD ./build /

ENTRYPOINT ["sh"]
