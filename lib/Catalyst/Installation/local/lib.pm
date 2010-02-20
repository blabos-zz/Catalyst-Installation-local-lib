package Catalyst::Installation::local::lib;

use warnings;
use strict;

=head1 NOME

Catalyst::Installation::local::lib - Instalação do Catalyst usando local::lib

=head1 VERSÃO

Versão 0.01

=cut

our $VERSION = '0.01';


=head1 INTRODUÇÃO

Uma das grandes forças do Perl é o incrível repositório CPAN. Nele encontramos uma grande quantidade de componentes para resolver os mais cabulosos problemas. Bastam alguns comandos simples para que os mais produtivos e eficazes frameworks estejam disponíveis.

Infelizmente, em ambientes onde não posuimos permissões de administrador, instalar um componente externo no sistema pode ser na melhor das hipóteses uma grande dor de cabeça.

Entretanto, quando falamos de Perl isso não é um problema, pois utilizando o módulo local::lib podemos instalar nossos componentes em um diretório arbitrário, como nosso diretório pessoal, por exemplo.

O principal requisito é ter disponível um compilador C e os pacotes de desenvolvimento da libc (quando aplicável). Alguns módulos compilam partes escritas em C.

Neste texto mostraremos como configurar o Perl para instalar os módulos do cpan localmente via local::lib em uma máquina na qual não possuimos permissões administrativas. Em seguida abordaremos também a instalação do Catalyst, bem como alguns tópicos opcionais.

=head1 CPAN COM LOCAL::LIB

A configuração do módulo local::lib é extremamente simples e rápida. Vamos tomar como exemplo uma instalação "virgem" do Perl em uma máquina com Ubuntu.

O primeiro passo é configurar o aplicativo cpan, que já vem com a a instalação padrão do Perl, e o qual será usado para instalar todos os módulos a seguir.

Para isso, basta chamar um terminal e digitar o comando cpan. Ele vai mostrar uma pequena mensagem de apresentação e perguntar se você gostaria de deixá-lo configurar tudo automaticamente. Para a maioria dos casos a configuração automática é suficiente, no entanto vamos configurar algumas opções um pouco diferentes do default, então respondemos ‘no’.

    Would you like me to configure as much as possible automatically? [yes] no

A primeira opção que eu vou responder diferente da default é a que define a política de pré-requisitos. Ela define o que o cpan deve fazer ao se deparar com um módulo que possui um dependência. O default é ‘ask’ (perguntar). Vamos modificar para ‘follow’ (seguir). Assim, quando o cpan encontrar um módulo que possui alguma dependência, ao invés de me perguntar, ele vai tentar instalá-la automaticamente. Isso é extremamente útil durante instalações longas com uma árvore de dependências grande como a do Catalyst.

    <prerequisites_policy>
    Policy on building prerequisites (follow, ask or ignore)? [ask] follow

Na sequência vem a pergunta sobre a instalação de dependências de build dos módulos. Vamos alterar de ‘ask/yes’ para ‘yes’ para que as dependências de build também sejam instaladas, assim se durante o build algum módulo precisar de outro que ainda não está instalado, este será instalado automaticamente. O default era perguntar e sugerir sim como resposta.

    <build_requires_install_policy>
    Policy on installing 'build_requires' modules (yes, no, ask/yes,
    ask/no)? [ask/yes] yes

A seguir vem uma sequência de perguntas sobre ferramentas que o cpan normalmente usa. Note que o cpan automaticamente descobre o PATH das ferramentas instaladas mas permite que esse PATH seja alterado. Com isso, caso alguma das ferramentas não esteja disponível, é possível instalá-las em um diretório qualquer e apontar para elas.

    <bzip2>
    Where is your bzip2 program? [/bin/bzip2]
 
    <gzip>
    Where is your gzip program? [/bin/gzip]

Várias opções depois, a próxima razoavelmente relevante para se modificar é o charset utilizado. Se o seu terminal suportar UTF-8, essa opção é preferível. Na maioria dos sistemas que usa o inglês como idioma padrão charset default é o ISO-8859-1. Respondendo 'yes' a essa pergunta, utilizaremos o padrão ISO-8859-1. Respondendo 'no' utilizaremos UTF-8.

    The next option deals with the charset (aka character set) your
    terminal supports. In general, CPAN is English speaking territory, so
    the charset does not matter much but some CPAN have names that are
    outside the ASCII range. If your terminal supports UTF-8, you should
    say no to the next question. If it expects ISO-8859-1 (also known as
    LATIN1) then you should say yes. If it supports neither, your answer
    does not matter because you will not be able to read the names of some
    authors anyway. If you answer no, names will be output in UTF-8.
    
    <term_is_latin>
    Your terminal expects ISO-8859-1 (yes/no)? [yes] no

O cpan vai perguntar se ele pode se conectar à internet para baixar a lista de repositórios. Ele é bem educado quanto às coisas que ele precisa fazer, por isso estamos configurando opções que o deixem mais independente. Responda 'yes' e aguarde ele baixar a lista de servidores.

Depois de se comunicar com os servidores default, ele pergunta quais repositórios você quer configurar em três etapas. Primeiro pergunta o continente, depois o país e por último o próprio repositório. É possível escolher mais de uma opção simultaneamente. Eu escolhi para continentes América do Sul e América do Norte, para países Brasil, Chile e Estados Unidos e por último alguns repositórios em cada país. Fique à vontade para escolher quantos e quais quiser.

Pronto. Agora você está no lendário shell do cpan.

    cpan[1]>

O próximo passo é instalar e configurar o módulo local::lib. Para isso digite no shell do cpan o comando:

    cpan[1]> look local::lib

Isso vai fazer com o que o cpan baixe o módulo mas não instale-o automaticamente. Ao invés disso ele vai abrir um novo shell no diretório local onde ele desempacotou o módulo local::lib.

Neste shell, faça o bootstrap com os seguintes comandos:

    user@host:~/.cpan/build/local-lib-1.004003-UyX2wf$ perl Makefile.PL \
    --bootstrap && make test && make install

Por último mas não menos importante é preciso exportar algumas variáveis de ambiente. Para isso saia do shell atual (Ctrl+D), saia do shell do cpan (bye ou quit) e execute no bash o seguinte comando:

    echo 'eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)' >>~/.bashrc

Isso vai adicionar os comandos que exportam as variáveis de ambiente ao final do seu arquivo .bashrc, e então a cada login elas serão automaticamente exportadas.

Force a re-execução do seu bashrc ou faça logout e login novamente

    user@host:~$ . ~/.bashrc

IMPORTANTE: Certifique-se que as variáveis de ambiente foram configuradas ou coisas estranhas podem acontecer. Entenda por “coisas estranhas” qualquer coisa diferente do funcionamento correto. Algumas podem ser realmente bizarras.

    user@host:~$ env | grep perl
    PERL5LIB=/home/catalyst/perl5/lib/perl5:/home/catalyst/perl5/lib/perl5...
    MODULEBUILDRC=/home/catalyst/perl5/.modulebuildrc
    PATH=/home/catalyst/perl5/bin:/usr/local/bin:/usr/bin:/bin:/usr/games
    PERL_MM_OPT=INSTALL_BASE=/home/catalyst/perl5
    user@host:~$

Caso você obtenha uma saída semelhante à mostrada acima significa que aparentemente está tudo ok. Caso contrário tente reiniciar o processo do começo. Para isso basta remover os diretórios .cpan e perl5 que foram criados durante o processo e recomeçar.

Caso você ainda tenha problemas, pode ser que exista alguma anomalia mais grave com a distribuição Perl em seu sistema. Neste caso ente em contato com o admistrador ou com o monge mais próximo.

Agora, antes de começar a instalar módulos, é uma boa atualizar o próprio módulo CPAN.pm. Atente para as maiúsculas e minúsculas.
    
    user@host:~$ cpan CPAN
    ...
    Installing /home/catalyst/perl5/bin/cpan
    Writing /home/catalyst/perl5/lib/perl5/i486-linux-gnu-thread-multi/auto...
    Appending installation info to /home/catalyst/perl5/lib/perl5/i486-linux...
      ANDK/CPAN-1.9402.tar.gz
      /usr/bin/make install  -- OK
    Warning (usually harmless): 'YAML' not installed, will not store persist...
    user@host:~$

Depois da instalação da nova versão do CPAN.pm, note que ele está avisando que o módulo YAML não está instalado. Para deixar tudo redondinho vamos intalá-lo também.

    user@host:~$ cpan YAML
    ...
    Writing /home/catalyst/perl5/lib/perl5/i486-linux-gnu-thread-multi/auto/Y...
    Appending installation info to /home/catalyst/perl5/lib/perl5/i486-linux...
      INGY/YAML-0.68.tar.gz
      /usr/bin/make install  -- OK
    CPAN: YAML loaded ok (v0.68)
    Going to read 1 yaml file from /home/catalyst/.cpan/build/
    DONE
    Restored the state of none (in 0.0265 secs)
    user@host:~$

Agora sim. Vamos dar uma conferida onde foi parar o módulo YAML recém instalado:

    user@host:~$ ls ~/perl5/lib/perl5
    CPAN  CPAN.pm  i486-linux-gnu-thread-multi  local  Test  YAML  YAML.pm
    user@host:~$

Ele foi instalado dentro de uma árvore de diretórios criada no home do usuário corrente, conforme planejávamos e tudo isso sem pedir a senha de root uma única vez.

=head1 MINICPAN (OPCIONAL)

Já vimos como instalar módulos do cpan localmente sem necessitar de privilégios administrativos. Entretanto, a dependência de uma conexão à internet para a instalação de novos módulos, é por vezes um empecilho para a utilização desta poderosa ferramenta. Como em Perl sempre há mais de uma forma de se fazer, neste texto também mostraremos como criar um mini-mirror do cpan para ser utilizado em ambientes onde uma conexão com a internet nem sempre é possível.

Depois de configurar o aplicativo cpan para instalar módulos localmente com a local::lib, o primeiro passo para configurar o mirror é instalar e configurar o módulo CPAN::Mini e seus aplicativos.

Existem várias formas de se configurar o minicpan. A que eu mais uso é a que é feita através de um arquivo de configuração chamado .minicpanrc que deve ser criado no diretório home do usuário corrente. Ele possui somente duas linhas conforme abaixo:

    local: ~/minicpan
    remote: http://www.cpan.org

A primeira linha indica em qual diretório ficarão os arquivos do mirror, enquanto a segunda indica de onde as informações sobre os pacotes serão baixadas.

Feito isso, podemos instalar o módulo CPAN::Mini com o comando:

    user@host:~$ cpan CPAN::Mini

Depois de instalar o módulo, executamos o comando minicpan que vai sincronizar o repositório indicado no ‘remote’ do .minicpanrc com o repositório na internet. Esta parte pode demorar entre alguns minutos e várias horas, dependendo da velocidade do seu link, pois ele vai baixar cerca de 1.2 GB de arquivos.

    user@host-perl:~$ minicpan
    authors/01mailrc.txt.gz ... updated
    modules/02packages.details.txt.gz ... updated
    modules/03modlist.data.gz ... updated
    authors/id/A/AA/AAYARS/Devel-Ladybug-0.406.tar.gz ... updated
    authors/id/A/AA/AAYARS/CHECKSUMS ... updated
    ...

A última etapa é configurar o aplicativo cpan para utilizar o nosso mirror local como primeira opção de download. Isso é feito através do próprio prompt do cpan:

    cpan> o conf urllist unshift file:///home/blabos/minicpan

Onde /home/blabos é o diretório home do usuário, no meu caso, blabos; e minicpan é o diretório que configuramos na opção ‘local’ do .minicpanrc.

Com esses passo simples, conseguimos construir um mini-mirror do cpan para ser utilizado em ambientes com pouco ou nenhum acesso à internet. Adicionalmente, para replicar o mirror em outras máquinas, basta copiar o diretório minicpan e adicioná-lo como opção de download para o comando cpan (última etapa descrita anteriormente).

=head1 INSTALANDO O CATALYST

=head1 ARMADILHAS COMUNS

=head1 MÓDULOS ADICIONAIS (OPCIONAL)

=head1 AUTOR

Blabos de Blebe, C<< <blabos at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalyst-installation-local-lib at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-Installation-local-lib>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Catalyst::Installation::local::lib


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Catalyst-Installation-local-lib>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Catalyst-Installation-local-lib>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Catalyst-Installation-local-lib>

=item * Search CPAN

L<http://search.cpan.org/dist/Catalyst-Installation-local-lib/>

=back


=head1 AGRADECIMENTOS


=head1 LICENÇA E COPYRIGHT

Copyright 2010 Blabos de Blebe.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Catalyst::Installation::local::lib
