//
//  Mod1Aula3Exe4ViewController.h
//  Musicando
//
//  Created by Emerson Barros on 06/07/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//
#import "Biblioteca.h"
#import "Conversa.h"
#import "Fala.h"
#import <AVFoundation/AVFoundation.h>
#import "Nota.h"
#import "Sinfonia.h"
#import "EfeitoImagem.h"
#import "EfeitoMascote.h"
#import "EfeitoBarraSuperior.h"
#import <QuartzCore/QuartzCore.h>
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>

@interface Mod1Aula3Exe4ViewController : UIViewController

/*==============================VIEWS===============================*/

//Mascote: Imagem, label e gesture
@property (strong, nonatomic) IBOutlet UILabel *lblFalaDoMascote;
@property (strong, nonatomic) IBOutlet UIView *viewGesturePassaFala;
@property (strong, nonatomic) IBOutlet UIImageView *imagemDoMascote;

@property (strong, nonatomic) IBOutlet UIImageView *vitrola;
@property (strong, nonatomic) IBOutlet UIImageView *notasDeHarmonia;

//Tocador: tocatreco, notas, instrumentos
@property (strong, nonatomic) IBOutlet UIImageView *notasHarmonia;
@property (strong, nonatomic) IBOutlet UIImageView *notaMelodia;
@property (strong, nonatomic) IBOutlet UIImageView *violao;
@property (strong, nonatomic) IBOutlet UIImageView *flauta;
@property (strong, nonatomic) IBOutlet UIImageView *tocaTreco;

/*===========================ATRIBUTOS=============================*/

//Audio
@property AVAudioPlayer *audioPlayer;
@property NSURL *caminhoDoAudio;

//Lista de imagens que precisam de colisao
@property NSMutableArray *listaImangesColisao;

//Auxiliares da Biblioteca
@property Biblioteca *testaBiblio;
@property Conversa *testaConversa;
@property Fala *testaFala;
@property int contadorDeFalas;

//Auxiliares para liberar fala quando todas as colisoes acontecerem
@property NSMutableArray *listaLiberaFala;
@property NSString *estadoAux1;
@property NSString *estadoAux2;
@property NSString *estadoAux3;

@end
