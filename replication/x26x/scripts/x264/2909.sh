#!/bin/sh

numb='2910'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 40 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.5,1.4,1.4,3.8,0.4,0.6,0.7,0,1,10,40,210,2,22,20,5,0,69,38,1,2000,-1:-1,hex,show,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"