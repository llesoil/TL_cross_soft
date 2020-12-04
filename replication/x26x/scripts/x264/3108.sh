#!/bin/sh

numb='3109'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 5 --keyint 230 --lookahead-threads 2 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.5,1.0,1.4,0.6,0.2,0.8,0.1,3,2,2,5,230,2,27,30,5,4,62,48,6,1000,-2:-2,dia,show,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"