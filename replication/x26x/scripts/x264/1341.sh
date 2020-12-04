#!/bin/sh

numb='1342'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 30 --keyint 220 --lookahead-threads 4 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.0,1.0,0.4,0.2,0.7,0.0,2,2,12,30,220,4,30,10,4,4,64,18,4,2000,-2:-2,hex,show,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"