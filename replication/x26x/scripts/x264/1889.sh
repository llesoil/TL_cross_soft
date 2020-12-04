#!/bin/sh

numb='1890'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 20 --keyint 230 --lookahead-threads 3 --min-keyint 20 --qp 20 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.4,1.0,2.4,0.4,0.9,0.3,3,0,0,20,230,3,20,20,3,0,64,28,4,2000,-2:-2,hex,show,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"