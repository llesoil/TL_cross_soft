#!/bin/sh

numb='943'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 5 --keyint 260 --lookahead-threads 0 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.1,1.4,1.2,0.6,0.9,0.9,1,2,16,5,260,0,28,10,3,0,68,38,2,2000,1:1,dia,crop,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"