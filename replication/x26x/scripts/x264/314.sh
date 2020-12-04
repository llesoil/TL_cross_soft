#!/bin/sh

numb='315'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 4.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 50 --keyint 300 --lookahead-threads 0 --min-keyint 27 --qp 20 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.0,1.1,4.6,0.6,0.7,0.8,1,1,0,50,300,0,27,20,4,2,66,48,2,2000,-1:-1,hex,show,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"