#!/bin/sh

numb='1251'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 35 --keyint 230 --lookahead-threads 4 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.0,1.2,1.6,0.3,0.7,0.1,2,0,0,35,230,4,21,30,5,4,61,28,3,2000,-2:-2,hex,show,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"