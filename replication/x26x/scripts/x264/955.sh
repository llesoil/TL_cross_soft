#!/bin/sh

numb='956'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 0 --keyint 250 --lookahead-threads 0 --min-keyint 25 --qp 40 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.3,1.0,3.0,0.4,0.7,0.6,2,0,8,0,250,0,25,40,4,1,62,28,1,2000,-2:-2,hex,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"