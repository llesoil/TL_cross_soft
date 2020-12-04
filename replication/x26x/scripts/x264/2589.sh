#!/bin/sh

numb='2590'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 40 --keyint 220 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.3,1.2,2.0,0.6,0.9,0.9,3,1,16,40,220,2,26,10,5,1,60,48,3,1000,1:1,umh,crop,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"