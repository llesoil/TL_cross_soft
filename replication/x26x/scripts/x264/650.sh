#!/bin/sh

numb='651'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 25 --keyint 210 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.1,1.4,2.0,0.6,0.7,0.3,2,0,2,25,210,4,21,40,4,3,60,38,3,1000,-1:-1,hex,crop,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"