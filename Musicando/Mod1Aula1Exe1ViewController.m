//
//  Mod1Aula1Exe1ViewController.m
//  Musicando
//
//  Created by Vinicius Resende Fialho on 19/06/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//
#import "Mod1Aula1Exe1ViewController.h"
#import "BarraSuperiorViewController.h"

@interface Mod1Aula1Exe1ViewController ()

@end

@implementation Mod1Aula1Exe1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Add barra Superior ao Xib
    [[EfeitoBarraSuperior sharedManager]addBarraSuperioAoXib:self:[Biblioteca sharedManager].exercicioAtual];
    
    //Chama a view de Introducao
    [self performSelector:@selector(animacaoMaoMascote) withObject:NULL afterDelay:0.1f];
    
    
   }

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


/////////////////////////////////// ANIMACAO INTRODUCAO GESTURE ////////////////////////////////////////

//Botao que aparece na view introducao
- (IBAction)btnComecar:(id)sender {
    
    
    ////////////remove animacoes da intro---> só é usado nessa view///////////
    [[EfeitoImagem sharedManager]removeTodasAnimacoesView:self.imgMaoTouch];
    [[EfeitoMascote sharedManager]removeBrilho:self.imgMascoteIntro:self.viewGesturePassaFala];
    [[EfeitoImagem sharedManager]removeTodasAnimacoesView:self.imgMascoteIntro];
    /////////////////////////////////////////////////////////////////////////
    
    
    //Oculta a intro
    self.viewInicialGesture.hidden = YES;
    
    //Habilita o gesture do mascote com a UIView que fica por cima dele
    //Coloquei essa view para colocar o gesture de pular fala, pois com animation atrapalha
    [self addGesturePassaFalaMascote:self.viewGesturePassaFala];
    
    
    //Lista para cair animcao/colisao
    self.listaImagensCai = [[NSMutableArray alloc]init];
    self.listaImangesColisao = [[NSMutableArray alloc]init];
    //Add imagens que faram colisao
    [self.listaImangesColisao addObject:self.imgFitaFuracao];
    [self.listaImangesColisao addObject:self.imgFitaGalo];
    [self.listaImangesColisao addObject:self.imgFitaCarro];
    [self.listaImangesColisao addObject:self.imgObjetoMusica1];
    [self.listaImangesColisao addObject:self.imgObjetoMusica2];
    [self.listaImangesColisao addObject:self.imgObjetoMusica3];
    //Add gesture arrastar em todas imagens dessa lista
    [[EfeitoImagem sharedManager]addGesturePainImagens:self.listaImangesColisao];
    
    
    //Lista para saber se as colisoes na tela foram feitas p/ ir na prox fala
    self.listaLiberaFala = [[NSMutableArray alloc]init];
    //seta com alguma coisa para add uma coisa nao nula
    self.estadoAux1 = @"0";
    self.estadoAux2 = @"0";
    self.estadoAux3 = @"0";
    
    //Biblioteca
    self.contadorDeFalas = 0;
    self.testaBiblio = [Biblioteca sharedManager];
    self.testaConversa = self.testaBiblio.exercicioAtual.mascote.listaDeConversas.firstObject;
    //Usar sempre que quiser pular uma fala,no caso tem que passar para pegar a primeira fala
    [self pulaFalaMascote];
    //Imagem do mascote
    self.imagemDoMascote2.image = [[[[Biblioteca sharedManager] exercicioAtual] mascote] imagem].image;
    //Add animacao de pular o mascote
    [[EfeitoMascote sharedManager]chamaAnimacaoMascotePulando:self.imagemDoMascote2];

    //Animcao para cair notas
    [self lacoCaindoNotas];
    
}

-(void)animacaoMaoMascote {
    
    //Add brilho e pulo a esse mascote que está na tela de intruducao
    [[EfeitoMascote sharedManager]chamaAddBrilho:self.imgMascoteIntro:2.0f:self.viewGesturePassaFala];
    [[EfeitoMascote sharedManager]chamaAnimacaoMascotePulando:self.imgMascoteIntro];
    
    //Altera a profundidade da mão para poder ficar na frente da imagem do mascote
    self.imgMaoTouch.layer.zPosition = 10;
    
    
    //Animcao da mão até o mascote
    [UIView animateWithDuration:2.0
                          delay:3.0
                        options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         
                        CGRect moveGalo = CGRectMake(self.imgMaoTouch.frame.origin.x+380,
                                                      self.imgMaoTouch.frame.origin.y-40,
                                                      self.imgMaoTouch.frame.size.width,
                                                      self.imgMaoTouch.frame.size.height);
                         self.imgMaoTouch.frame = moveGalo;
                         
                     }
                     completion:^(BOOL finished){
                         //Add sprite as imagem da mão e comeca (tem uma parar no EfeitoImagem caso necesario)
                         UIImage *image1 = [UIImage imageNamed:@"gesturePassaFalaMascote.png"];
                         UIImage *image2 = [UIImage imageNamed:@"gesturePassaFalaMascoteTap.png"];
                         NSArray *imageArray = [NSArray arrayWithObjects:image1,image2,nil];
                         [[EfeitoImagem sharedManager]addAnimacaoSprite:imageArray:self.imgMaoTouch];
                         
                         //mostra o botao comecar
                         self.outBtnComecar.hidden = NO;
                         
                     }];

    
    
}

//////////////////////////// Colisoes //////////////////////////////

////// colisao Galo
-(void) checkColisaoGalo:(NSTimer *) theTimer{
    id presentationLayer1 = self.imgTocaTreco.layer.presentationLayer;
    id presentationLayer2 = self.imgFitaGalo.layer.presentationLayer;
    BOOL nowIntersecting = CGRectIntersectsRect([presentationLayer1 frame], [presentationLayer2 frame]);
    
    //Tira e desoculta a animacao de introdudacao de como jogar objetos no tocaTreco
    UIPanGestureRecognizer *aux = self.imgFitaGalo.gestureRecognizers.firstObject;
    if (aux.numberOfTouches == 1){
        [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgGaloMao];
        [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgMaoTocaTreco];
    }
    
    if (nowIntersecting){
        self.imgFitaGalo.hidden = true;
        self.imgFitaGalo.frame = self.imgTocaTreco.frame;
        [self.listaLiberaFala addObject:self.estadoAux1];
      
        [theTimer invalidate];
        [self acaoColisaoAnimal];
    }
 
}

////// colisao Carro
-(void) checkColisaoCarro:(NSTimer *) theTimer{
    id presentationLayer1 = self.imgTocaTreco.layer.presentationLayer;
    id presentationLayer2 = self.imgFitaCarro.layer.presentationLayer;
    BOOL nowIntersecting = CGRectIntersectsRect([presentationLayer1 frame], [presentationLayer2 frame]);
    
    //Tira e desoculta a animacao de introdudacao de como jogar objetos no tocaTreco
    UIPanGestureRecognizer *aux = self.imgFitaCarro.gestureRecognizers.firstObject;
    if (aux.numberOfTouches == 1){
        [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgGaloMao];
        [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgMaoTocaTreco];
    }
    
    if (nowIntersecting){
        self.imgFitaCarro.hidden = true;
        self.imgFitaCarro.frame = self.imgFitaCarro.frame;
        [self.listaLiberaFala addObject:self.estadoAux2];
        [theTimer invalidate];
        [self acaoColisaoCarro];
    }
    
}

////// colisao Vento
-(void) checkColisaoVento:(NSTimer *) theTimer{
    id presentationLayer1 = self.imgTocaTreco.layer.presentationLayer;
    id presentationLayer2 = self.imgFitaFuracao.layer.presentationLayer;
    BOOL nowIntersecting = CGRectIntersectsRect([presentationLayer1 frame], [presentationLayer2 frame]);
    
    //Tira e desoculta a animacao de introdudacao de como jogar objetos no tocaTreco
    UIPanGestureRecognizer *aux = self.imgFitaFuracao.gestureRecognizers.firstObject;
    if (aux.numberOfTouches == 1){
        [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgGaloMao];
        [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgMaoTocaTreco];
    }
    
    if (nowIntersecting){
        self.imgFitaFuracao.hidden = true;
        self.imgFitaFuracao.frame = self.imgFitaFuracao.frame;
        [self.listaLiberaFala addObject:self.estadoAux3];
        [theTimer invalidate];
        [self acaoColisaoVento];
    }
    
}

////// colisao Objeto 1 estranho
-(void) checkColisaoObjeto1:(NSTimer *) theTimer{
    id presentationLayer1 = self.imgTocaTreco.layer.presentationLayer;
    id presentationLayer2 = self.imgObjetoMusica1.layer.presentationLayer;
    BOOL nowIntersecting = CGRectIntersectsRect([presentationLayer1 frame], [presentationLayer2 frame]);
    
    if (nowIntersecting){
        self.imgObjetoMusica1.hidden = true;
        self.imgObjetoMusica1.frame = self.imgObjetoMusica1.frame;
        [self.listaLiberaFala addObject:self.estadoAux1];
        
        self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"musicaCristal" withExtension:@"mp3"];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
        [[self audioPlayer]play];
        
        [theTimer invalidate];
    }
    
}

////// colisao Objeto 2 estranho
-(void) checkColisaoObjeto2:(NSTimer *) theTimer{
    id presentationLayer1 = self.imgTocaTreco.layer.presentationLayer;
    id presentationLayer2 = self.imgObjetoMusica2.layer.presentationLayer;
    BOOL nowIntersecting = CGRectIntersectsRect([presentationLayer1 frame], [presentationLayer2 frame]);
    
    if (nowIntersecting){
        self.imgObjetoMusica2.hidden = true;
        self.imgObjetoMusica2.frame = self.imgObjetoMusica2.frame;
        [self.listaLiberaFala addObject:self.estadoAux2];
        
        self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"musicaPanela" withExtension:@"mp3"];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
        [[self audioPlayer]play];
        
        [theTimer invalidate];
    }
    
}

////// colisao Objeto 3 estranho
-(void) checkColisaoObjeto3:(NSTimer *) theTimer{
    id presentationLayer1 = self.imgTocaTreco.layer.presentationLayer;
    id presentationLayer2 = self.imgObjetoMusica3.layer.presentationLayer;
    BOOL nowIntersecting = CGRectIntersectsRect([presentationLayer1 frame], [presentationLayer2 frame]);
    
    if (nowIntersecting){
        self.imgObjetoMusica3.hidden = true;
        self.imgObjetoMusica3.frame = self.imgObjetoMusica3.frame;
        [self.listaLiberaFala addObject:self.estadoAux3];
        
        self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"musicaPalmas" withExtension:@"mp3"];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
        [[self audioPlayer]play];
        
        [theTimer invalidate];
    }
}


///////////////////////////////  Metodos de cada Fala /////////////////////////////
//OBS: sempre em cada metodo desse, deva aparecer o metodo removeBrilho e chamaAddBrilho, para
//poder tirar o passar de fala e depois liberar o passar de fala
//Tem dois jeitos de se liberar o passar fala, e usa os seguitnes metodos:

//-chamaAddBrilho:self.imagemDoMascote2:5.0f:self.viewGesturePassaFala -> consegue colocar o tempo
//que vc quer até o liberar fala aconteca, necessario caso haja só texto

//chamaVerficadorPassaFala:self.imagemDoMascote2 :self.viewGesturePassaFala:self.listaLiberaFala:3 ->
//só libera a fala quando as colisoes acontecerem


-(void)chamaMetodosFala0 {
    [[EfeitoMascote sharedManager]chamaAddBrilho:self.imagemDoMascote2:5.0f:self.viewGesturePassaFala];
}

-(void)chamaMetodosFala1 {
    [[EfeitoMascote sharedManager]removeBrilho:self.imagemDoMascote2:self.viewGesturePassaFala];
    [[EfeitoMascote sharedManager]chamaAddBrilho:self.imagemDoMascote2:5.0f:self.viewGesturePassaFala];
}

-(void)tocaIndio{
    self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"indio" withExtension:@"mp3"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
    [[self audioPlayer]play];
}

-(void)tocaCarnaval{
    self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"carnaval" withExtension:@"mp3"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
    [[self audioPlayer]play];
}

-(void)tocaCapoeira{
    self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"capoeira" withExtension:@"mp3"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
    [[self audioPlayer]play];
}

-(void)chamaMetodosFala2 {
    [[EfeitoMascote sharedManager]removeBrilho:self.imagemDoMascote2:self.viewGesturePassaFala];
    
    //Remove todas as animacoes que estao na lista, no caso estou tirando as notas que caiem
    [[EfeitoImagem sharedManager]removeTodasAnimacoesViewLista:self.listaImagensCai];
    
    //Mostra imagem oculta
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgIndioMusica];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgCarnaval];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgCapoeiraMusica];
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgAnimacaoIndio];
    UIImage *image1 = [UIImage imageNamed:@"animaIndio1.gif"];
    UIImage *image2 = [UIImage imageNamed:@"animaIndio2.gif"];
    NSArray *imageArray = [NSArray arrayWithObjects:image1,image2,nil];
    [[EfeitoImagem sharedManager]addAnimacaoSprite:imageArray:self.imgAnimacaoIndio];
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgAnimacaoCarnaval];
    UIImage *image3 = [UIImage imageNamed:@"carnavalframe1.gif"];
    UIImage *image4 = [UIImage imageNamed:@"carnavalframe2.gif"];
    UIImage *image5 = [UIImage imageNamed:@"carnavalframe3.gif"];
    UIImage *image6 = [UIImage imageNamed:@"carnavalframe4.gif"];
    UIImage *image7 = [UIImage imageNamed:@"carnavalframe5.gif"];
    UIImage *image8 = [UIImage imageNamed:@"carnavalframe6.gif"];
    NSArray *imageArray2 = [NSArray arrayWithObjects:image3,image4,image5,image6,image7,image8,nil];
    [[EfeitoImagem sharedManager]addAnimacaoSprite:imageArray2:self.imgAnimacaoCarnaval];
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgAnimacaoCapoeira];
    UIImage *image9 = [UIImage imageNamed:@"Capoeiraframe1.gif"];
    UIImage *image10 = [UIImage imageNamed:@"Capoeiraframe2.gif"];
    UIImage *image11 = [UIImage imageNamed:@"Capoeiraframe3.gif"];
    NSArray *imageArray3 = [NSArray arrayWithObjects:image9,image10,image11,nil];
    [[EfeitoImagem sharedManager]addAnimacaoSprite:imageArray3:self.imgAnimacaoCapoeira];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         CGRect moveGalo = CGRectMake(self.imgIndioMusica.frame.origin.x+500,
                                                      self.imgIndioMusica.frame.origin.y,
                                                      self.imgIndioMusica.frame.size.width,
                                                      self.imgIndioMusica.frame.size.height);
                         
                         self.imgIndioMusica.frame = moveGalo;
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:6.0
                                               delay:3.0
                                             options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                                          animations:^{
                                              [NSTimer scheduledTimerWithTimeInterval: 3.0
                                                                               target: self
                                                                             selector: @selector(tocaIndio)
                                                                             userInfo: nil
                                                                              repeats: NO];
                                            CGRect moveGalo2 = CGRectMake(self.imgAnimacaoIndio.frame.origin.x+330,
                                                                            self.imgAnimacaoIndio.frame.origin.y,
                                                                            self.imgAnimacaoIndio.frame.size.width,
                                                                            self.imgAnimacaoIndio.frame.size.height);
                                              self.imgAnimacaoIndio.frame = moveGalo2;
                                          }
                                          completion:(NULL)];
                     }];
    
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         CGRect moveGalo = CGRectMake(self.imgCarnaval.frame.origin.x+680,
                                                      self.imgCarnaval.frame.origin.y,
                                                      self.imgCarnaval.frame.size.width,
                                                      self.imgCarnaval.frame.size.height);
                         self.imgCarnaval.frame = moveGalo;
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:6.0
                                               delay:9.0
                                             options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                                          animations:^{
                                              [NSTimer scheduledTimerWithTimeInterval: 9.0
                                                                               target: self
                                                                             selector: @selector(tocaCarnaval)
                                                                             userInfo: nil
                                                                              repeats: NO];
                                              CGRect moveGalo2 = CGRectMake(self.imgAnimacaoCarnaval.frame.origin.x+550,
                                                                            self.imgAnimacaoCarnaval.frame.origin.y,
                                                                            self.imgAnimacaoCarnaval.frame.size.width,
                                                                            self.imgAnimacaoCarnaval.frame.size.height);
                                              self.imgAnimacaoCarnaval.frame = moveGalo2;
                                          }
                                          completion:(NULL)];
                     }];

    
    
    [UIView animateWithDuration:6.0
                          delay:0.0
                        options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         CGRect moveGalo = CGRectMake(self.imgCapoeiraMusica.frame.origin.x+840,
                                                      self.imgCapoeiraMusica.frame.origin.y,
                                                      self.imgCapoeiraMusica.frame.size.width,
                                                      self.imgCapoeiraMusica.frame.size.height);
                         
                         self.imgCapoeiraMusica.frame = moveGalo;
                         
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:6.0
                                               delay:16.0
                                             options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                                          animations:^{
                                              [NSTimer scheduledTimerWithTimeInterval: 16.0
                                                                               target: self
                                                                             selector: @selector(tocaCapoeira)
                                                                             userInfo: nil
                                                                              repeats: NO];
                                              CGRect moveGalo2 = CGRectMake(self.imgAnimacaoCapoeira.frame.origin.x+710,
                                                                            self.imgAnimacaoCapoeira.frame.origin.y,
                                                                            self.imgAnimacaoCapoeira.frame.size.width,
                                                                            self.imgAnimacaoCapoeira.frame.size.height);
                                              self.imgAnimacaoCapoeira.frame = moveGalo2;
                                          }
                                          completion:^(BOOL finished){
                                              [[EfeitoMascote sharedManager]chamaAddBrilho:self.imagemDoMascote2:1.0f:self.viewGesturePassaFala];
                                          }];
                     }];
    

}

-(void)chamaMetodosFala3 {
    [[EfeitoMascote sharedManager]removeBrilho:self.imagemDoMascote2:self.viewGesturePassaFala];
    
    [[self audioPlayer]stop];
    
    //Tira e mostra imagem oculta
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgIndioMusica];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgCapoeiraMusica];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgCarnaval];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgAnimacaoCapoeira];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgAnimacaoCarnaval];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgAnimacaoIndio];
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgTocaTreco];
    
    
    [[EfeitoMascote sharedManager]chamaAddBrilho:self.imagemDoMascote2:5.0f:self.viewGesturePassaFala];
    
}

-(void)chamaMetodosFala4 {
    
    [[EfeitoMascote sharedManager]removeBrilho:self.imagemDoMascote2:self.viewGesturePassaFala];
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgMaoTocaTreco];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgGaloMao];
    
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:  UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         CGRect moveGalo = CGRectMake(self.imgMaoTocaTreco.frame.origin.x,
                                                      self.imgMaoTocaTreco.frame.origin.y+140,
                                                      self.imgMaoTocaTreco.frame.size.width,
                                                      self.imgMaoTocaTreco.frame.size.height);
                         CGRect moveGalo2 = CGRectMake(self.imgGaloMao.frame.origin.x,
                                                      self.imgGaloMao.frame.origin.y+140,
                                                      self.imgGaloMao.frame.size.width,
                                                      self.imgGaloMao.frame.size.height);
                         self.imgMaoTocaTreco.frame = moveGalo;
                         self.imgGaloMao.frame = moveGalo2;
                         
                     }
                     completion:(NULL)];
    
    
    //Fica verificando se as imagens colidiram, se acontecer ele altera o valor para 1 dos 3 estados
    //e depois add em uma lista que verificará se todas tiveram colisao
    [NSTimer scheduledTimerWithTimeInterval: 0.5
                                     target: self
                                   selector: @selector(checkColisaoGalo:)
                                   userInfo: nil
                                    repeats: YES];
    
    [NSTimer scheduledTimerWithTimeInterval: 0.5
                                     target: self
                                   selector: @selector(checkColisaoCarro:)
                                   userInfo: nil
                                    repeats: YES];
    
    [NSTimer scheduledTimerWithTimeInterval: 0.5
                                     target: self
                                   selector: @selector(checkColisaoVento:)
                                   userInfo: nil
                                    repeats: YES];
    
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgFitaCarro];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgFitaGalo];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgFitaFuracao];
    
    self.imgTocaTreco.userInteractionEnabled = YES;
    
    //Metodo que verifica o passar fala, nele tem que passar a qt de objetos que colidirá nessa fala, no caso 3
    [[EfeitoImagem sharedManager]chamaVerficadorPassaFala:self.imagemDoMascote2 :self.viewGesturePassaFala:self.listaLiberaFala:3];
    
    
}

-(void)chamaMetodosFala5 {
    
    [[EfeitoMascote sharedManager]removeBrilho:self.imagemDoMascote2:self.viewGesturePassaFala];
    
    [[self audioPlayer]stop];
    
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgPipaGrande];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgCarroGrande];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgGaloGrande];

    
    [[EfeitoImagem sharedManager]removeTodasAnimacoesView:self.imgGaloMao];
    [[EfeitoImagem sharedManager]removeTodasAnimacoesView:self.imgMaoTocaTreco];
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.outAlavancaTocaTreco];
    
    
    
}

//-(void)rotate:(id)sender {
//    
//    
//    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
//    [rotationRecognizer setDelegate:self];
//    [self.outAlavancaTocaTreco addGestureRecognizer:rotationRecognizer];
//    
//    //lastRotation is a cgfloat member variable
//    
//    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
//        _lastRotation = 0.0;
//        return;
//    }
//    
//    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
//    
//    CGAffineTransform currentTransform = self.outAlavancaTocaTreco.transform;
//    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
//    
//    [self.outAlavancaTocaTreco setTransform:newTransform];
//    
//    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
//}


- (IBAction)btnAlavancaTocaTreco:(id)sender {
    
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         self.outAlavancaTocaTreco.transform = CGAffineTransformRotate(self.outAlavancaTocaTreco.transform, ((10 * M_PI) / 180.0));
                     }
                     completion:^(BOOL finished){
                         self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"musicaMixaIntroducao" withExtension:@"wav"];
                         self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
                         [[self audioPlayer]play];
                         
                         [[EfeitoMascote sharedManager]chamaAddBrilho:self.imagemDoMascote2:8.0f:self.viewGesturePassaFala];
                     }];
    
   
}


-(void)chamaMetodosFala6 {
    
    [[EfeitoMascote sharedManager]removeBrilho:self.imagemDoMascote2:self.viewGesturePassaFala];

    [[self audioPlayer]stop];
    
    [[EfeitoImagem sharedManager]removeTodasAnimacoesView:self.imgPipaGrande];
    [[EfeitoImagem sharedManager]removeTodasAnimacoesView:self.imgCarroGrande];
    [[EfeitoImagem sharedManager]removeTodasAnimacoesView:self.imgGaloGrande];
    
    
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.outAlavancaTocaTreco];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgTocaTreco];

    
    [[EfeitoMascote sharedManager]chamaAddBrilho:self.imagemDoMascote2:5.0f:self.viewGesturePassaFala];
    
}


-(void)chamaMetodosFala7 {
    
    [[EfeitoMascote sharedManager]removeBrilho:self.imagemDoMascote2:self.viewGesturePassaFala];
    
    [[EfeitoImagem sharedManager]removeTodasAnimacoesViewLista:self.listaImagensCai];
    
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgObjetoMusica1];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgObjetoMusica2];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgObjetoMusica3];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgTocaTreco];
    
    
    [NSTimer scheduledTimerWithTimeInterval: 0.5
                                     target: self
                                   selector: @selector(checkColisaoObjeto1:)
                                   userInfo: nil
                                    repeats: YES];
    
    [NSTimer scheduledTimerWithTimeInterval: 0.5
                                     target: self
                                   selector: @selector(checkColisaoObjeto2:)
                                   userInfo: nil
                                    repeats: YES];
    
    [NSTimer scheduledTimerWithTimeInterval: 0.5
                                     target: self
                                   selector: @selector(checkColisaoObjeto3:)
                                   userInfo: nil
                                    repeats: YES];
    
    
    [[EfeitoImagem sharedManager]chamaVerficadorPassaFala:self.imagemDoMascote2 :self.viewGesturePassaFala:self.listaLiberaFala:3];
    
}

-(void)chamaMetodosFala8 {

    [[EfeitoMascote sharedManager]removeBrilho:self.imagemDoMascote2:self.viewGesturePassaFala];
    [[EfeitoMascote sharedManager]chamaAddBrilho:self.imagemDoMascote2:5.0f:self.viewGesturePassaFala];
    
    [[self audioPlayer]stop];
    
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgObjetoMusica1];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgObjetoMusica2];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgObjetoMusica3];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgTocaTreco];
    
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgBen3];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgBen2];
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgBen1];
    
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         CGRect moveGalo = CGRectMake(self.imgBen3.frame.origin.x+280,
                                                      self.imgBen3.frame.origin.y,
                                                      self.imgBen3.frame.size.width,
                                                      self.imgBen3.frame.size.height);
                         self.imgBen3.frame = moveGalo;
                         
                     }
                     completion:(NULL)];
    
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         CGRect moveGalo = CGRectMake(self.imgBen2.frame.origin.x+480,
                                                      self.imgBen2.frame.origin.y,
                                                      self.imgBen2.frame.size.width,
                                                      self.imgBen2.frame.size.height);
                         self.imgBen2.frame = moveGalo;
                         
                     }
                     completion:(NULL)];
    
    
    [UIView animateWithDuration:6.0
                          delay:0.0
                        options:  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         CGRect moveGalo = CGRectMake(self.imgBen1.frame.origin.x+680,
                                                      self.imgBen1.frame.origin.y,
                                                      self.imgBen1.frame.size.width,
                                                      self.imgBen1.frame.size.height);
                         self.imgBen1.frame = moveGalo;
                         
                     }
                     completion:(NULL)];
    
    
    [[EfeitoMascote sharedManager]chamaAddBrilho:self.imagemDoMascote2:8.0f:self.viewGesturePassaFala];
    
}

-(void)chamaMetodosFala9 {
    
//    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgBen3];
//    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgBen2];
//    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgBen1];
    
    [[EfeitoMascote sharedManager]removeBrilho:self.imagemDoMascote2:self.viewGesturePassaFala];
    [[EfeitoMascote sharedManager]chamaAddBrilho:self.imagemDoMascote2:5.0f:self.viewGesturePassaFala];
}


//Gerencia o passa de falas
-(void)pulaFalaMascote{
    //Usa pra não dar erro de nulo na ultima fala
    int contadorMaximo = (int)self.testaConversa.listaDeFalas.count;
    

    if(self.contadorDeFalas == contadorMaximo){
        NSString *proxExercicio = [[Biblioteca sharedManager]exercicioAtual].nomeView;
        [[Biblioteca sharedManager]chamaViewTransicaoExercicio:self:proxExercicio];
    }
    
    if(self.contadorDeFalas < contadorMaximo){
        switch (self.contadorDeFalas) {
            case 0:
                [self chamaMetodosFala0];
                break;
            case 1:
                [self chamaMetodosFala1];
                break;
            case 2:
                [self chamaMetodosFala2];
                break;
            case 3:
                [self chamaMetodosFala3];
                break;
            case 4:
                [self chamaMetodosFala4];
                break;
            case 5:
                [self chamaMetodosFala5];
                break;
            case 6:
                [self chamaMetodosFala6];
                break;
            case 7:
                [self chamaMetodosFala7];
                break;
            case 8:
                [self chamaMetodosFala8];
                break;
            case 9:
                [self chamaMetodosFala9];
                break;
            default:
                break;
        }
        
        self.testaFala = [self.testaConversa.listaDeFalas objectAtIndex:self.contadorDeFalas];
        self.lblFalaDoMascote.text = self.testaFala.conteudo;
        
        self.contadorDeFalas +=1;
    }
}

//Add gesture passar de fala a view que fica por cima do mascote, usei por cauda do problema da animacao
-(void)addGesturePassaFalaMascote:(UIView*)viewGesture{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pulaFalaMascote)];
    singleTap.numberOfTouchesRequired = 1;
    singleTap.enabled = NO;
    viewGesture.userInteractionEnabled = NO;
    [viewGesture addGestureRecognizer:singleTap];

}


////////////////////////// ACOES DA COLISAO ////////////////////////

//Fazem as imagens sairem da esquerda até direita, no caso o Galo,Carro,Vento
-(void)deslocaImagemGrandeParaDireita:(UIImageView*)imgGrande :(float)duracaoAnimacao{
    CGRect posGaloOriginal = imgGrande.frame;
    
    [UIView animateWithDuration:duracaoAnimacao
                     animations:^(void){
                         imgGrande.hidden = NO;
                         CGRect moveGalo = CGRectMake(1050,
                                                      imgGrande.frame.origin.y,
                                                      imgGrande.frame.size.width,
                                                      imgGrande.frame.size.height);
                         imgGrande.frame = moveGalo;
                     } completion:^(BOOL finished){
                         imgGrande.hidden = YES;
                         imgGrande.frame = posGaloOriginal;
                     }];
    
}

- (void)acaoColisaoAnimal{
    
    self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"galo" withExtension:@"wav"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
    [[self audioPlayer]play];
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgGaloGrande];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgCarroGrande];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgPipaGrande];
  
    [self deslocaImagemGrandeParaDireita:self.imgGaloGrande:3.0];
   

}

- (void)acaoColisaoCarro {
    self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"carro" withExtension:@"wav"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
    
    [[self audioPlayer]play];
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgCarroGrande];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgGaloGrande];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgPipaGrande];
    
    [self deslocaImagemGrandeParaDireita:self.imgCarroGrande:7.0];
    
    
}

- (void)acaoColisaoVento {
    self.caminhoDoAudio = [[NSBundle mainBundle] URLForResource:@"vento" withExtension:@"wav"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: self.caminhoDoAudio error: nil];
    
    [[self audioPlayer]play];
    [[self audioPlayer]setVolume:5.0];
    
    [[EfeitoImagem sharedManager]hiddenNoEmDegrade:self.imgPipaGrande];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgGaloGrande];
    [[EfeitoImagem sharedManager]hiddenYesEmDegrade:self.imgCarroGrande];
    
    
    [self deslocaImagemGrandeParaDireita:self.imgPipaGrande:7.0];
}


//////////////////////////////// METODOS NOTAS CAINDO /////////////////////////
//Toca audio Nota
-(void)tocaNotaPulando:(NSString*)nomeNota{
    Nota *aux = [[Nota alloc]init];
    aux.nomeNota = nomeNota;
    aux.oitava = @"5";
    aux.tom = @"";
    aux.tipoNota = @"quarter";
    self.listaSons = [[NSMutableArray alloc]init];
    [self.listaSons addObject:aux];
    [[Sinfonia sharedManager]tocarUmaNota:self.listaSons:@"Piano"];
}

-(NSMutableArray*)addFormaAleatoria{
    
    NSMutableArray *storeArray = [[NSMutableArray alloc] init];
    BOOL record = NO;
    int x;
    
    for (int i=0; [storeArray count] < 13; i++) //Loop for generate different random values
    {
        x = arc4random() % 13;//generating random number
        if(i==0)//for first time
        {
            [storeArray addObject:[NSNumber numberWithInt:x]];
        }
        else
        {
            for (int j=0; j<= [storeArray count]-1; j++)
            {
                if (x ==[[storeArray objectAtIndex:j] intValue])
                    record = YES;
            }
            
            if (record == YES)
            {
                record = NO;
            }
            else
            {
                [storeArray addObject:[NSNumber numberWithInt:x]];
            }
        }
    }

    return storeArray;

}

-(void)lacoCaindoNotas{
    
    self.duracao = 3.0;
    self.delay = 0.0;
    self.posX = -100;
    CGFloat posY=0;
    NSString *nomeNota;
    NSMutableArray *contaAl = [self addFormaAleatoria];

        for(int i=0;i<13;i++){
            UIImageView *notaCaindo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notaParaRosto.png"]];
            UIImageView *carinha = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notaCaraPausaSom.png"]];
            carinha.frame = CGRectMake(carinha.frame.origin.x+13,
                                       carinha.frame.origin.y+130,
                                       30,
                                       30);
            [notaCaindo addSubview:carinha];
            
            //Add sprite as imagem da mão e comeca (tem uma parar no EfeitoImagem caso necesario)
            UIImage *image1 = [UIImage imageNamed:@"notaCaraPausaSom.png"];
            UIImage *image2 = [UIImage imageNamed:@"notaCaraTocaSom.png"];
            NSArray *imageArray = [NSArray arrayWithObjects:image1,image2,nil];
            [[EfeitoImagem sharedManager]addAnimacaoSprite:imageArray:carinha];
            
            notaCaindo.frame = CGRectMake(self.posX,-100,notaCaindo.frame.size.width+40,notaCaindo.frame.size.height+70);
            [[self listaImagensCai]addObject:notaCaindo];
            [self.view addSubview:notaCaindo];
            
            switch (i) {
                case 1:
                    nomeNota = @"C";
                    break;
                case 2:
                    nomeNota = @"D";
                    break;
                case 3:
                    nomeNota = @"E";
                    break;
                case 4:
                    nomeNota = @"F";
                    break;
                case 5:
                    nomeNota = @"G";
                    break;
                case 6:
                    nomeNota = @"A";
                    break;
                default:
                    break;
            }
            if(i<5) posY = 540;
            else posY = 340;
            
            
            self.posX += 100;
            [self animacaoCaindoNotas:notaCaindo:self.duracao:self.posX:posY:self.delay:nomeNota];
            self.delay = [[contaAl objectAtIndex:i]floatValue];

            
        }
    
}



-(void)animacaoCaindoNotas:(UIImageView*)notaCaindo :(float)duracao :(CGFloat)posX :(CGFloat)posY :(float)tempoDemrora :(NSString*)nomeNota{
    //UIViewAnimationOptionAutoreverse ,UIViewAnimationOptionCurveEaseInOut,UIViewAnimationOptionTransitionCrossDissolv
    
    [UIView animateWithDuration:duracao
                          delay:tempoDemrora
                        options:  UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         [notaCaindo.layer removeAnimationForKey:@"1"];
                         CGRect moveGalo = CGRectMake(posX,
                                                      posY,
                                                      notaCaindo.frame.size.width,
                                                      notaCaindo.frame.size.height);
                         notaCaindo.frame = moveGalo;
                      }
                     completion:^(BOOL finished){
                         notaCaindo.hidden = YES;
                     }];
    
    
}


@end
