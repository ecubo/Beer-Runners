//
//  r4bSecondViewController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 08/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bSecondViewController.h"
#import "r4bAgendaItemViewController.h"

@interface r4bSecondViewController ()
    @property (nonatomic) NSURLSession *session;
    @property (nonatomic, copy) NSArray *noticias;
    @property (nonatomic) NSString *filtro;
    @property (nonatomic) UIAlertView *alert;
    @property (nonatomic) UITableView *tableView;
@end

@implementation r4bSecondViewController
static NSString *cellIdentifier;
@synthesize textView,scrollView,tags;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //Seteo el tableView de filtro de ciudades
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, [[UIScreen mainScreen] bounds].size.width, 500)];
    self.tableView.hidden = TRUE;
    cellIdentifier = @"tagCell";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //Acciones del botón de ver por tags
    id searchTopButton = [[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                       target:self
                       action:@selector(searchTopButtonPressed:)
                       ];
    self.navigationItem.rightBarButtonItem=searchTopButton;
    
    tags = [NSMutableArray arrayWithObjects:
                                  @"Todas", nil];
    
    //Cojo el JSON
    NSData *elJsonGuardado;
    elJsonGuardado = [self getSavedJsonData];
    
    NSDictionary *jsonEnDisco=[NSJSONSerialization
                               JSONObjectWithData:elJsonGuardado
                               options:NSJSONReadingMutableLeaves
                               error:nil];
    
    
    [scrollView setScrollEnabled:true];
    
    float ancho = [[UIScreen mainScreen] bounds].size.width - 40;
    
    CGFloat altoDelScrollView;
    altoDelScrollView = (70 + 120 * [jsonEnDisco[@"all"][@"noticias"] count]);

    [scrollView setContentSize:CGSizeMake(ancho, altoDelScrollView)];
    
    NSInteger cuenta;
    cuenta = 0;
    CGFloat vertical = 0;
    CGFloat altoTotal = 70;
    
    for (NSDictionary *dictionary in jsonEnDisco[@"all"][@"noticias"])
    {
        NSString *fechaEvento;
        NSString *NombreEvento;
        NSString *DescEvento;
        NSString *TagEvento;
        
        fechaEvento = dictionary[@"fecha"];
        if ([fechaEvento  isEqual: @""]) {
            fechaEvento = @"";
        }
        NombreEvento = dictionary[@"titulo"];
        if ([NombreEvento  isEqual: @""]) {
            NombreEvento = @"";
        }
        DescEvento = dictionary[@"minidesc"];
        
        /* Limpio caracteres */
        // Defining what characters to accept
        NSMutableCharacterSet *acceptedCharacters = [[NSMutableCharacterSet alloc] init];
        [acceptedCharacters formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
        [acceptedCharacters formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
        [acceptedCharacters addCharactersInString:@" _-.!"];
        
        // Turn accented letters into normal letters (optional)
        NSData *sanitizedData = [DescEvento dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        // Corrected back-conversion from NSData to NSString
        NSString *sanitizedText = [[NSString alloc] initWithData:sanitizedData encoding:NSASCIIStringEncoding];
        
        // Removing unaccepted characters
        NSString* DescEventoLimpio = [[sanitizedText componentsSeparatedByCharactersInSet:[acceptedCharacters invertedSet]] componentsJoinedByString:@""];
    
        /* FIN Limpio caracteres */

        if ([DescEvento  isEqual: @""]) {
            DescEvento = @"";
        }
        TagEvento = dictionary[@"tag"];
        if ([TagEvento  isEqual: @""]) {
            TagEvento = @"";
        }
        
        //Convierto la fecha al formato adecuado
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateDate;
        dateDate = [df dateFromString: fechaEvento];

        NSDateFormatter *formatter;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"es"]];
        [formatter setDateFormat:@"dd MMMM yyyy"];
        fechaEvento = [formatter stringFromDate:dateDate];
        
        //Meto en tag para el tableView
        if (![tags containsObject:TagEvento] && ![TagEvento isEqualToString:@"Sin tag"] && ![TagEvento isEqualToString:@"General"]) {
            [tags addObject:TagEvento];
        }
        
        
        if (!(self.filtro == nil) && ![self.filtro isEqualToString:@"Todas"] && ![self.filtro isEqualToString:@"Sin tag"]) {
            if (![dictionary[@"tag"] isEqualToString:self.filtro] && ![dictionary[@"tag"] isEqualToString:@"General"]) {
                continue;
            }
        }
        
        NSString *textViewText = [NSString stringWithFormat:@"%@\n%@\n%@",fechaEvento,NombreEvento,DescEvento];

        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:textViewText];
        //Fecha
        [attributedText addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"Bebas Neue" size:20]
                               range:[textViewText rangeOfString:fechaEvento]];
        [attributedText addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithRed:255/255.0 green:205/255.0 blue:0/255.0 alpha:1]
                               range:[textViewText rangeOfString:fechaEvento]];
        
        //Título
        [attributedText addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"Bebas Neue" size:27]
                               range:[textViewText rangeOfString:NombreEvento]];
        [attributedText addAttribute:NSForegroundColorAttributeName
                               value:[UIColor whiteColor]
                               range:[textViewText rangeOfString:NombreEvento]];
        
        //Descripción
        [attributedText addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"Helvetica" size:12]
                               range:[textViewText rangeOfString:DescEvento]];
        [attributedText addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]
                               range:[textViewText rangeOfString:DescEvento]];
        
        
        /* calculo alto */
        //Fecha
        UIFont *fontFecha = [UIFont fontWithName:@"Bebas Neue" size:20];
        CGSize constraintFecha = CGSizeMake(ancho - (20 * 2), 20000.0f);
        NSDictionary *attributesFecha = @{NSFontAttributeName: fontFecha};
        CGRect rectFecha = [fechaEvento boundingRectWithSize:constraintFecha
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes:attributesFecha
                                           context:nil];
        //Nombre
        UIFont *fontNombre = [UIFont fontWithName:@"Bebas Neue" size:27];
        //CGSize constraintNombre = CGSizeMake(ancho,1000);
        CGSize constraintNombre = CGSizeMake(ancho - (20 * 2), 20000.0f);
        NSDictionary *attributesNombre = @{NSFontAttributeName: fontNombre};
        CGRect rectNombre = [NombreEvento boundingRectWithSize:constraintNombre
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:attributesNombre
                                                     context:nil];
        //Descripción
        UIFont *fontDesc = [UIFont fontWithName:@"Helvetica" size:12];
        CGSize constraintDesc = CGSizeMake(ancho - (20 * 2), 20000.0f);
        NSDictionary *attributesDesc = @{NSFontAttributeName: fontDesc};
        CGRect rectDesc = [DescEventoLimpio boundingRectWithSize:constraintDesc
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:attributesDesc
                                                     context:nil];
        
        float alto = rectFecha.size.height + rectNombre.size.height + rectDesc.size.height + 20;
        altoTotal = altoTotal + alto;
        /* FIN calculo alto */
        
        if (cuenta == 0) {
            vertical = 70;
        }
        else{
            vertical = vertical + 20;
        }
        textView = [[UITextView alloc] initWithFrame:CGRectMake(20, vertical, ancho, alto)];
        
        vertical = vertical + alto;
        
        cuenta = cuenta +1;
        
        textView.scrollEnabled = NO;
        textView.pagingEnabled = NO;
        textView.editable = NO;
        textView.backgroundColor = [UIColor blackColor];
        
        textView.attributedText = attributedText;

        //Le pongo padding
        textView.textContainerInset = UIEdgeInsetsMake(6, 6, 0, 0);
        
        textView.scrollEnabled = FALSE;
        
        //Muestro la vista
        [scrollView addSubview:textView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        //Añado el label para sacar el ID de la noticia en el evento
        [singleTap setAccessibilityLabel:[NSString stringWithFormat:@"%@", dictionary[@"id"]]];
        [self.textView addGestureRecognizer:singleTap];
    }
    
    float altoScrollFinal = (40 * (cuenta + 1)) + altoTotal;
    //NSLog(@"altoScrollFinal: %f",altoScrollFinal);
    [scrollView setContentSize:CGSizeMake(ancho, altoScrollFinal )];
    
}

-(NSData *)getSavedJsonData{
    NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/all.json"];
    
    return [NSData dataWithContentsOfFile:jsonPath];
}

-(void)handleSingleTap: (UITapGestureRecognizer *)recognizer{
    //handle tap in here
    [self buttonAction:@[recognizer.accessibilityLabel]];

}

-(void)buttonAction:(id)sender
{
    [self performSegueWithIdentifier:@"viewAgendaItemSegue" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"viewAgendaItemSegue"])
    {
        r4bAgendaItemViewController *viewController = [segue destinationViewController];
        viewController.myValue = sender[0];
    }
}

- (void)searchTopButtonPressed:(UIButton *)button {
    if (self.tableView.hidden) {
        self.tableView.hidden = FALSE;
        //Hago que se muestre por encima de todos los demás elementos.
        [self.view insertSubview:self.tableView atIndex:99];
    } else {
        self.tableView.hidden = TRUE;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [tags objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.hidden = TRUE;
    for (int i=0; i<[tags count]; i++) {
        if (indexPath.item == i) {
            self.filtro = tags[i];
            NSArray *subviews = [scrollView subviews];
            for(int i = 0; i < subviews.count; i++)
            {
                UIImageView *imageView = (UIImageView *)[subviews objectAtIndex:i];
                [imageView removeFromSuperview];
            }
            
            [self viewDidLoad];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
