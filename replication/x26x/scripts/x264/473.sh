#!/bin/sh

numb='474'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 20 --keyint 220 --lookahead-threads 2 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.2,1.2,0.4,0.4,0.6,0.3,3,1,6,20,220,2,29,50,4,0,60,48,1,1000,-2:-2,dia,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"