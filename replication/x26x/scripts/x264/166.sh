#!/bin/sh

numb='167'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 45 --keyint 230 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.3,1.3,3.4,0.2,0.6,0.6,1,0,16,45,230,1,27,30,5,1,60,18,2,1000,-1:-1,hex,show,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"