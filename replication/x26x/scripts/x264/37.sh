#!/bin/sh

numb='38'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 40 --keyint 230 --lookahead-threads 2 --min-keyint 21 --qp 10 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.2,1.0,4.6,0.3,0.9,0.8,2,1,10,40,230,2,21,10,5,2,64,38,1,2000,-2:-2,dia,crop,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"