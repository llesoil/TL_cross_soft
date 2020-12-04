#!/bin/sh

numb='1315'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 2.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 45 --keyint 280 --lookahead-threads 0 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 0 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.4,1.2,2.2,0.4,0.9,0.9,3,2,12,45,280,0,20,0,5,0,69,18,2,1000,-1:-1,dia,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"