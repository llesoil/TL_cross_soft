#!/bin/sh

numb='1835'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 0.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 10 --keyint 290 --lookahead-threads 2 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.4,1.4,0.6,0.4,0.6,0.8,2,0,6,10,290,2,21,10,4,3,66,18,6,1000,-1:-1,dia,crop,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"