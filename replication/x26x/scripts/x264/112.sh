#!/bin/sh

numb='113'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 25 --keyint 260 --lookahead-threads 0 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.3,3.2,0.6,0.8,0.8,2,1,16,25,260,0,20,50,5,3,64,28,1,1000,-2:-2,hex,crop,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"