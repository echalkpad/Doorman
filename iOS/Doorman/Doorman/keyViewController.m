//
// This Software (the "Software") is supplied to you by Openmind Networks
// Limited ("Openmind") your use, installation, modification or
// redistribution of this Software constitutes acceptance of this disclaimer.
// If you do not agree with the terms of this disclaimer, please do not use,
// install, modify or redistribute this Software.
//
// TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED ON AN
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER
// EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR
// CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Each user of the Software is solely responsible for determining the
// appropriateness of using and distributing the Software and assumes all
// risks associated with use of the Software, including but not limited to
// the risks and costs of Software errors, compliance with applicable laws,
// damage to or loss of data, programs or equipment, and unavailability or
// interruption of operations.
//
// TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW OPENMIND SHALL NOT
// HAVE ANY LIABILITY FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, WITHOUT LIMITATION,
// LOST PROFITS, LOSS OF BUSINESS, LOSS OF USE, OR LOSS OF DATA), HOWSOEVER
// CAUSED UNDER ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
// WAY OUT OF THE USE OR DISTRIBUTION OF THE SOFTWARE, EVEN IF ADVISED OF
// THE POSSIBILITY OF SUCH DAMAGES.
//

//
//  keyViewController.m
//  Doorman
//
//  Created by Ian Harris on 30/07/2014.
//  Copyright (c) 2014 Golgi. All rights reserved.
//

#import "keyViewController.h"

@interface keyViewController ()

@end

@implementation keyViewController

@synthesize granterTextField, requesterTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    requesterTextField.delegate = self;
    granterTextField.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 160; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

// Hides Keyboard when return is pressed in a Textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loadDestinationVC:(id)sender {
    // check the granter e-mail address
    NSString *granter = granterTextField.text;
    NSString *requester = requesterTextField.text;
    NSString *usernameKey = @"username_preference";
    NSString *granterKey = @"granter_preference";
    GolgiWrapper *golgiWrapper;
    NSLog(@"Next button pushed");
    // check that they are both set
    if([granter isEqualToString:@""] || [requester isEqualToString:@""]){
        // don't proceed need more info
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Unset field"
                                                          message:@"Please complete all fields"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    else{
        NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
        [preferences setObject:requester forKey:usernameKey];
        [preferences setObject:granter forKey:granterKey];
        [preferences synchronize];
        NSLog(@"Attempting to allocate golgiWrapper");
        golgiWrapper = [[GolgiWrapper alloc] init];
        NSLog(@"Allocated golgiWrapper");
    }
    
    // check if this is a staff request
    if([granter isEqualToString:@"doorman@openmindnetworks.com"]){
        [self performSegueWithIdentifier:@"StaffSegue" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"VisitorSegue" sender:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
