#!/bin/sh

numb='584'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 5 --keyint 250 --lookahead-threads 1 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.5,1.3,1.3,1.2,0.2,0.9,0.9,2,1,16,5,250,1,22,10,5,2,60,48,6,1000,-2:-2,dia,crop,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"