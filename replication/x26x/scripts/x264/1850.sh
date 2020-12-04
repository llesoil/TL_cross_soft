#!/bin/sh

numb='1851'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 45 --keyint 210 --lookahead-threads 3 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.5,1.1,3.8,0.5,0.9,0.8,0,2,0,45,210,3,27,10,5,0,67,48,5,2000,-1:-1,hex,crop,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"