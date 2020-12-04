#!/bin/sh

numb='2646'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 15 --keyint 240 --lookahead-threads 4 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.6,1.0,4.6,0.5,0.6,0.3,3,2,12,15,240,4,27,30,4,1,68,28,2,2000,-2:-2,hex,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"