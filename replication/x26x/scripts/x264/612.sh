#!/bin/sh

numb='613'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 4.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 15 --keyint 290 --lookahead-threads 3 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.0,1.1,4.2,0.5,0.8,0.1,2,1,10,15,290,3,26,50,3,0,67,48,2,1000,-1:-1,dia,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"