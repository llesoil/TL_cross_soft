#!/bin/sh

numb='1863'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 15 --keyint 200 --lookahead-threads 1 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.5,1.1,0.4,0.6,0.7,0.3,3,2,4,15,200,1,22,0,4,3,68,48,2,1000,-2:-2,hex,show,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"