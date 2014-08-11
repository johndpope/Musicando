//
//  RetornaPaginaViewController.m
//  Musicando
//
//  Created by Vinicius Resende Fialho on 10/08/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//

#import "RetornaPaginaViewController.h"

@interface RetornaPaginaViewController ()

@end

@implementation RetornaPaginaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Singleton
+(RetornaPaginaViewController*)sharedManager{
    static RetornaPaginaViewController *mascote = nil;
    if(!mascote){
        mascote = [[super allocWithZone:nil] init];
    }
    return mascote;
}

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)addBarraSuperioAoXib:(UIViewController*)viewAtual :(Exercicio*)exer{
    
    RetornaPaginaViewController *bar = [[RetornaPaginaViewController alloc]init];
    bar.view.layer.zPosition = 0;
    [viewAtual addChildViewController:bar];
    bar.view.frame = CGRectMake(0, 740, bar.view.frame.size.width,bar.view.frame.size.height);
    [viewAtual.view addSubview:bar.view];
    
}

-(void)retornaViewDoExercicio:(UIViewController*)viewController{
    for(UIView *img in viewController.view.subviews){
        if((img.tag == 1000)||(img.tag == 1001)||(img.tag == 1002)||(img.tag == 1003)) {
        }else {
            img.hidden = YES;
        }
    }
}


-(void)voltaView{
    
    NSLog(@"string %d",self.contadorDeFalas);

    self.contadorDeFalas = [MascoteViewController sharedManager].contadorDeFalas;
    
    NSLog(@"dep %d",self.contadorDeFalas);
    
    if(self.contadorDeFalas >1){
        [self retornaViewDoExercicio:self];
        self.contadorDeFalas = self.contadorDeFalas -2;
        
        [NSTimer scheduledTimerWithTimeInterval:0.0
                                         target:self.cont
                                       selector:self.metodo
                                       userInfo:nil
                                        repeats:NO];
        
        [[EfeitoTransicao sharedManager]chamaTransicaoPaginaTopo:self];
        
    }
    
}

-(void)addGesturePassaFalaMascote:(UIView*)viewVoltaFala :(int)contadorFala :(SEL)nomeMetodo :(UIViewController*)cont{
    
    self.metodo = nomeMetodo;
    self.cont = cont;
    
    UISwipeGestureRecognizer *singleTap2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(voltaView)];
    singleTap2.numberOfTouchesRequired = 1;
    singleTap2.direction = UISwipeGestureRecognizerDirectionRight;
    viewVoltaFala.userInteractionEnabled = YES;
    [viewVoltaFala addGestureRecognizer:singleTap2];
    
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}


-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear: animated];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end