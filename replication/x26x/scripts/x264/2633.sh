#!/bin/sh

numb='2634'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 30 --keyint 230 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.0,1.1,0.2,0.5,0.6,0.8,0,0,14,30,230,1,30,40,4,2,63,18,6,1000,1:1,umh,crop,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"