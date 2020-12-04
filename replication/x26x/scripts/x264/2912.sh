#!/bin/sh

numb='2913'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 10 --keyint 300 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.5,1.2,0.8,0.4,0.6,0.7,0,0,8,10,300,0,30,30,3,0,65,18,1,2000,-1:-1,umh,show,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"