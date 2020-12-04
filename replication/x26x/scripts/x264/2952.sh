#!/bin/sh

numb='2953'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 10 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.5,1.4,4.8,0.5,0.8,0.8,1,2,2,10,230,0,23,10,4,1,67,48,2,1000,-1:-1,hex,show,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"