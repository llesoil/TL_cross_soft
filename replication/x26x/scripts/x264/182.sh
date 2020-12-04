#!/bin/sh

numb='183'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 25 --keyint 260 --lookahead-threads 1 --min-keyint 21 --qp 20 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.0,1.3,1.6,0.2,0.7,0.3,1,0,6,25,260,1,21,20,4,0,65,48,2,2000,-2:-2,dia,crop,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"