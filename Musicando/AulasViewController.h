//
//  AulasViewController.h
//  Musicando
//
//  Created by VINICIUS RESENDE FIALHO on 18/06/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Biblioteca.h"
#import "Modulo.h"
#import "Aula.h"
#import "Exercicio.h"

@interface AulasViewController : UIViewController {
    
}

@property Biblioteca *bibliotecaDosModulos;
@property Aula *aulaAtual;
@property (strong, nonatomic) IBOutlet UIView *viewExercicios;

@property CGRect posOriginalAula;

@end
