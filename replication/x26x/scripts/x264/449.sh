#!/bin/sh

numb='450'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 45 --keyint 270 --lookahead-threads 4 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.0,1.6,1.2,4.0,0.2,0.9,0.2,3,1,16,45,270,4,26,40,5,2,62,48,4,2000,-1:-1,hex,crop,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"