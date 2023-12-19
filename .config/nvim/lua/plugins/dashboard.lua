return {
	"goolord/alpha-nvim",
	opts = function(_, dashboard)
		local logos = {
			[[
         ,_---~~~~~----._         
  _,,_,*^____      _____``*g*\"*, 
 / __/ /'     ^.  /      \ ^@q   f 
[  @f | @))    |  | @))   l  0 _/  
 \`/   \~____ / __ \_____/    \   
  |           _l__l_           I   
  }          [______]           I  
  ]            | | |            |  
  ]             ~ ~             |  
  |                            |   
   |                           |   
]],
			[[
    Just Do IT!
┻━┻︵ \(°□°)/ ︵ ┻━┻
]],
			[[
`;-.          ___,
  `.`\_...._/`.-"`
    \        /      ,
    /()   () \    .' `-._
   |)  .    ()\  /   _.'
   \  -'-     ,; '. <
    ;.__     ,;|   > \
   / ,    / ,  |.-'.-'
  (_/    (_/ ,;|.<`
    \    ,     ;-`
     >   \    /
    (_,-'`> .'
          (_,'
]],
			[[
         _nnnn_
        dGGGGMMb
       @p~qp~~qMb
       M|@||@) M|
       @,----.JM|
      JS^\__/  qKL
     dZP        qKRb
    dZP          qKKb
   fZP            SMMb
   HZM            MMMM
   FqM            MMMM
 __| ".        |\dS"qML
 |    `.       | `' \Zq
_)      \.___.,|     .'
\____   )MMMMMP|   .'
     `-'       `--'
        ]],
			[[
                                |     |
                                \\_V_//
                                \/=|=\/
                                 [=v=]
                               __\___/_____
                              /..[  _____  ]
                             /_  [ [  M /] ]
                            /../.[ [ M /@] ]
                           <-->[_[ [M /@/] ]
                          /../ [.[ [ /@/ ] ]
     _________________]\ /__/  [_[ [/@/ C] ]
    <_________________>>0---]  [=\ \@/ C / /
       ___      ___   ]/000o   /__\ \ C / /
          \    /              /....\ \_/ /
       ....\||/....           [___/=\___/
      .    .  .    .          [...] [...]
     .      ..      .         [___/ \___]
     .    0 .. 0    .         <---> <--->
  /\/\.    .  .    ./\/\      [..]   [..]
 / / / .../|  |\... \ \ \    _[__]   [__]_
/ / /       \/       \ \ \  [____>   <____]
            ]],
			[[
                                         )  (  (    (
                                         (  )  () @@  )  (( (
                                     (      (  )( @@  (  )) ) (
                                   (    (  ( ()( /---\   (()( (
     _______                            )  ) )(@ !O O! )@@  ( ) ) )
    <   ____)                      ) (  ( )( ()@ \ o / (@@@@@ ( ()( )
 /--|  |(  o|                     (  )  ) ((@@(@@ !o! @@@@(@@@@@)() (
|   >   \___|                      ) ( @)@@)@ /---\-/---\ )@@@@@()( )
|  /---------+                    (@@@@)@@@( // /-----\ \\ @@@)@@@@@(  .
| |    \ =========______/|@@@@@@@@@@@@@(@@@ // @ /---\ @ \\ @(@@@(@@@ .  .
|  \   \\=========------\|@@@@@@@@@@@@@@@@@ O @@@ /-\ @@@ O @@(@@)@@ @   .
|   \   \----+--\-)))           @@@@@@@@@@ !! @@@@ % @@@@ !! @@)@@@ .. .
|   |\______|_)))/             .    @@@@@@ !! @@ /---\ @@ !! @@(@@@ @ . .
 \__==========           *        .    @@ /MM  /\O   O/\  MM\ @@@@@@@. .
    |   |-\   \          (       .      @ !!!  !! \-/ !!  !!! @@@@@ .
    |   |  \   \          )   -cfbd-   .  @@@@ !!     !!  .(. @.  .. .
    |   |   \   \        (    /   .(  . \)). ( |O  )( O! @@@@ . )      .
    |   |   /   /         ) (      )).  ((  .) !! ((( !! @@ (. ((. .   .
    |   |  /   /   ()  ))   ))   .( ( ( ) ). ( !!  )( !! ) ((   ))  ..
    |   |_<   /   ( ) ( (  ) )   (( )  )).) ((/ |  (  | \(  )) ((. ).
____<_____\\__\__(___)_))_((_(____))__(_(___.oooO_____Oooo.(_(_)_)((_
            ]],
			[[
                      ^\    ^
                      / \\  / \
                     /.  \\/   \      |\___/|
  *----*           / / |  \\    \  __/  O  O\
  |   /          /  /  |   \\    \_\/  \     \
 / /\/         /   /   |    \\   _\/    '@___@
/  /         /    /    |     \\ _\/       |U
|  |       /     /     |      \\\/        |
\  |     /_     /      |       \\  )   \ _|_
\   \       ~-./_ _    |    .- ; (  \_ _ _,\'
~    ~.           .-~-.|.-*      _        {-,
 \      ~-. _ .-~                 \      /\'
  \                   }            {   .*
   ~.                 '-/        /.-~----.
     ~- _             /        >..----.\\\
         ~ - - - - ^}_ _ _ _ _ _ _.-\\\
            ]],
			[[
     |\                                                              /|
     | \                                                            / |
     |  \                                                          /  |
     |   \                                                        /   |
     |    \                                                      /    |
_____)     \                                                    /     (___
\           \                                                 /          /
 \           \                                                /          /
  \           `--_____                                _____--'          /
   \                  \                              /                 /
____)                  \                            /                 (____
\                       \        /|      |\        /                      /
 \                       \      | /      \ |      /                      /
  \                       \     ||        ||     /                      /
   \                       \    | \______/ |    /                      /
    \                       \  / \        / \  /                      /
    /                        \| (*\  \/  /*) |/                       \
   /                          \   \| \/ |/   /                         \
  /                            |   |    |   |                           \
 /                             |\ _\____/_ /|                            \
/______                       | | \)____(/ | |                      ______\
       )                      |  \ |/vv\| /  |                     (
      /                      /    | |  | |    \                     \
     /                      /     ||\^^/||     \                     \
    /                      /     / \====/ \     \                     \
   /_______           ____/      \________/      \____           ______\
           )         /   |       |  ____  |       |   \         (
           |       /     |       \________/       |     \       |
           |     /       |       |  ____  |       |       \     |
           |   /         |       \________/       |         \   |
           | /            \      \ ______ /      /______..    \ |
           /              |      \\______//      |        \     \
                          |       \ ____ /       |LLLLL/_  \
                          |      / \____/ \      |      \   |
                          |     / / \__/ \ \     |     __\  /__
                          |    | |        | |    |     \      /
                          |    | |        | |    |      \    /
                          |    |  \      /  |    |       \  /
                          |     \__\    /__/     |        \/
                         /    ___\  )  (  /___    \
                        |/\/\|    )      (    |/\/\|
                        ( (  )                (  ) )
            ]],
		}
		math.randomseed(os.time(os.date("!*t")) * 13)
		dashboard.section.header.val = vim.split(logos[math.random(#logos)], "\n")
	end,
}